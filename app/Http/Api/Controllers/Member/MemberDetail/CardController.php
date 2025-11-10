<?php

namespace App\Http\Api\Controllers\Member\MemberDetail;

use App\Http\Api\Requests\Member\Card\DestroyCardRequest;
use App\Http\Api\Requests\Member\Card\StoreCardRequest;
use App\Http\Api\Requests\Member\Card\UpdateCardRequest;
use App\Http\Controllers\Controller;
use App\Http\Responses\JsonResponse;
use App\Models\User;
use App\Models\UserCardMap;
use App\Services\UserCardService;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use InvalidArgumentException;

class CardController extends Controller
{
    protected $json;
    protected $userCardService;

    public function __construct(JsonResponse $json, UserCardService $userCardService)
    {
        $this->json = $json;
        $this->userCardService = $userCardService;
    }

    public function store(StoreCardRequest $request, User $user)
    {
        try {
            $payload = $this->buildCardPayload($user, $request->all());

            /** @var UserCardMap $card */
            $card = $this->userCardService->updateOrCreate($user, $payload);
            $card->load('reviews');

            return $this->json->success([
                'message' => trans('constants.message.create_success'),
                'card' => $this->transformCard($card),
            ]);
        } catch (InvalidArgumentException $e) {
            return $this->json->failed(-2, $e->getMessage());
        } catch (\Exception $e) {
            Log::error(format_exception($e, true));

            return $this->json->failed(-1, trans('constants.message.create_failed'));
        }
    }

    public function update(UpdateCardRequest $request, User $user, UserCardMap $card)
    {
        if (! $this->ownsActiveCard($user, $card)) {
            return $this->json->failed(-2, trans('constants.err_msg.invalid_params'));
        }

        try {
            $payload = $this->buildCardPayload($user, $request->all(), $card);

            $this->userCardService->update($card, $payload);

            $freshCard = UserCardMap::where('user_id', $user->id)
                ->where('is_history', false)
                ->where('card_type', $card->card_type)
                ->where('parameters->updated_from', $card->id)
                ->orderByDesc('id')
                ->first();

            if (! $freshCard) {
                $freshCard = UserCardMap::where('user_id', $user->id)
                    ->where('card_type', $card->card_type)
                    ->where('is_history', false)
                    ->orderByDesc('id')
                    ->first();
            }

            return $this->json->success([
                'message' => trans('constants.message.update_success'),
                'card' => $freshCard ? $this->transformCard($freshCard->load('reviews')) : null,
            ]);
        } catch (InvalidArgumentException $e) {
            return $this->json->failed(-2, $e->getMessage());
        } catch (\Exception $e) {
            Log::error(format_exception($e, true));
            return $this->json->failed(-1, trans('constants.message.update_failed'));
        }
    }

    public function destroy(DestroyCardRequest $request, User $user, UserCardMap $card)
    {
        if (! $this->ownsActiveCard($user, $card)) {
            return $this->json->failed(-2, trans('constants.err_msg.invalid_params'));
        }

        try {
            $this->userCardService->destroyCard($user, $card->card_type, $card->id);

            return $this->json->success([
                'message' => trans('constants.message.delete_success'),
            ]);
        } catch (\Exception $e) {
            Log::error(format_exception($e, true));
            return $this->json->failed(-1, trans('constants.message.delete_failed'));
        }
    }

    protected function buildCardPayload(User $user, array $input, UserCardMap $card = null)
    {
        $cardType = strtolower($input['card_type'] ?? ($card ? $card->card_type : ''));

        if (! $cardType) {
            throw new InvalidArgumentException(trans('constants.err_msg.invalid_params'));
        }

        $type = $input['type'] ?? ($card ? $card->type : 'normal');
        $day = $input['day'] ?? null;

        $parseInput = [
            'crypto_network' => $input['crypto_network'] ?? ($card ? data_get($card->card_info, 'network') : null),
            'crypto_coin' => $input['crypto_coin'] ?? ($card ? data_get($card->card_info, 'coin') : null),
            'crypto_address' => $input['crypto_address'] ?? ($card ? data_get($card->card_info, 'address') : null),
        ];

        $parseSource = array_merge($input, $parseInput, ['card_type' => $cardType]);

        [$success, $cardInfo, $uniqueToken] = $this->userCardService->parseCardInfo(
            $user,
            $cardType,
            $parseSource
        );

        if (! $success) {
            throw new InvalidArgumentException(trans('constants.err_msg.invalid_params'));
        }

        if ($type === 'limited') {
            if ($day) {
                $expiredAt = Carbon::now()->addDays((int) $day)->toDateTimeString();
            } elseif ($card && $card->type === 'limited' && $card->expired_at) {
                $expiredAt = $card->expired_at->toDateTimeString();
            } else {
                throw new InvalidArgumentException(trans('constants.rule_message.required', ['field' => trans('user_card.day')]));
            }
        } else {
            $expiredAt = null;
        }

        return [
            'card_type' => $cardType,
            'type' => $type,
            'status' => $card ? $card->status : 2,
            'default' => $card ? $card->default : false,
            'card_info' => $cardInfo,
            'unique_token' => $uniqueToken,
            'expired_at' => $expiredAt,
        ];
    }

    protected function transformCard(UserCardMap $card)
    {
        $cardInfo = $card->card_info;
        if ($cardInfo instanceof \stdClass) {
            $cardInfo = json_decode(json_encode($cardInfo), true);
        }

        $rejectInfo = null;
        if ($card->status == 3) {
            $lastReview = $card->reviews()->orderByDesc('id')->first();
            if ($lastReview) {
                $rejectInfo = [
                    'reject_reason' => $lastReview->reject_reason,
                    'reject_reason_text' => $lastReview->reject_reason_text,
                    'reject_at' => $lastReview->review_at
                        ? $lastReview->review_at->format('Y-m-d H:i:s')
                        : null,
                ];
            }
        }

        return [
            'id' => $card->id,
            'card_number' => $card->card_number,
            'card_type' => $card->card_type,
            'status' => $card->status,
            'type' => $card->type,
            'default' => (bool) $card->default,
            'card_info' => $cardInfo,
            'expired_at' => $card->expired_at ? $card->expired_at->format('Y-m-d H:i:s') : null,
            'created_at' => $card->created_at ? $card->created_at->format('Y-m-d H:i:s') : null,
            'updated_at' => $card->updated_at ? $card->updated_at->format('Y-m-d H:i:s') : null,
            'reject_info' => $rejectInfo,
        ];
    }

    protected function ownsActiveCard(User $user, UserCardMap $card)
    {
        return $card->user_id === $user->id && ! $card->is_history;
    }
}
