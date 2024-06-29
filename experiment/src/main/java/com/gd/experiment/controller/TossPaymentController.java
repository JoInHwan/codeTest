package com.gd.experiment.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.gd.experiment.service.TossPaymentService;

import java.io.IOException;

@Controller
public class TossPaymentController {

    @Autowired
    private TossPaymentService tossPaymentService;

    @GetMapping("/createPayment")
    public String showCreatePaymentForm(Model model) {
        model.addAttribute("orderNo", "ORDER12345");
        model.addAttribute("amount", "10000");
        return "createPaymentForm"; // createPaymentForm.jsp로 이동
    }

    @PostMapping("/processPayment")
    public String processPayment(@RequestParam("orderNo") String orderNo,
                                 @RequestParam("amount") String amount,
                                 Model model) {

        try {
            String response = tossPaymentService.createPayment(orderNo, amount);
            // 여기서 response를 처리하고 필요한 작업을 수행합니다.
            // 예를 들어, Gson을 사용하여 JSON을 객체로 변환하여 추가 처리를 할 수 있습니다.
            
            model.addAttribute("orderNo", orderNo);
            model.addAttribute("amount", amount);
            model.addAttribute("message", "Payment successfully created!");

            return "paymentResult"; // paymentResult.jsp로 이동
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to create payment");
            return "errorPage"; // errorPage.jsp로 이동
        }
    }
}
