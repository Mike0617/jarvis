<?php

namespace App\Http\Api\Requests\Member\Card;

use App\Http\Api\Requests\BaseRequest;
use Illuminate\Support\Facades\Auth;

class StoreCardRequest extends BaseRequest
{
    public function authorize()
    {
        return Auth::user()->can('update-channels_auth');
    }

    public function rules()
    {
        return [
            'card_type' => 'required|string|in:crypto',
            'type' => 'required|string|in:normal,limited',
            'day' => 'required_if:type,limited|integer|min:1|max:30',
            'crypto_network' => 'required|string|max:100',
            'crypto_coin' => 'required|string|max:50',
            'crypto_address' => 'required|string|max:255',
        ];
    }

    public function messages()
    {
        return [
            'card_type' => -2,
            'type' => -3,
            'day' => -4,
            'crypto_network' => -5,
            'crypto_coin' => -6,
            'crypto_address' => -7,
        ];
    }
}
