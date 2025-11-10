<?php

namespace App\Http\Api\Requests\Member\Card;

use App\Http\Api\Requests\BaseRequest;
use Illuminate\Support\Facades\Auth;

class DestroyCardRequest extends BaseRequest
{
    public function authorize()
    {
        return Auth::user()->can('update-channels_auth');
    }

    public function rules()
    {
        return [];
    }

    public function messages()
    {
        return [];
    }
}
