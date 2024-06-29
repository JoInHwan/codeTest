package com.gd.experiment.service;
import okhttp3.*;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class TossPaymentService {

    private static final String TOSS_API_URL = "https://toss.im/tosspay/api/v1/payments";
    private static final String CLIENT_KEY = "test_sk_ORzdMaqN3weplJO1xJwgr5AkYXQG";
    private static final String SECRET_KEY = "test_sk_abcdefg";

    private OkHttpClient client = new OkHttpClient();

    public String createPayment(String orderNo, String amount) throws IOException {
        RequestBody requestBody = new FormBody.Builder()
                .add("apiKey", CLIENT_KEY)
                .add("orderNo", orderNo)
                .add("amount", amount)
                .build();

        Request request = new Request.Builder()
                .url(TOSS_API_URL)
                .addHeader("Authorization", "Bearer " + SECRET_KEY)
                .post(requestBody)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Failed to create payment: " + response);
            }

            return response.body().string();
        }
    }
}
