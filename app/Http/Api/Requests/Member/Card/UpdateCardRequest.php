<?php

namespace App\Http\Api\Requests\Member\Card;

use App\Http\Api\Requests\BaseRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Validator;

class UpdateCardRequest extends BaseRequest
{
    public function authorize()
    {
        return Auth::user()->can('update-channels_auth');
    }

    public function rules()
    {
        return [
            'type' => 'required|string|in:normal,limited',
            'day' => 'nullable|integer|min:1|max:30',
            'crypto_network' => 'sometimes|string|max:100',
            'crypto_coin' => 'sometimes|string|max:50',
            'crypto_address' => 'sometimes|string|max:255',
        ];
    }

    public function messages()
    {
        return [
            'type' => -3,
            'day' => -4,
            'crypto_network' => -5,
            'crypto_coin' => -6,
            'crypto_address' => -7,
        ];
    }

    protected function withValidator(Validator $validator)
    {
        if ($validator->fails()) {
            return;
        }

        $card = $this->route('card');
        $type = $this->input('type');
        $day = $this->input('day');

        if ($type === 'limited' && empty($day) && $card && $card->type !== 'limited') {
            $validator->errors()->add('day', -4);
        }
    }
}
