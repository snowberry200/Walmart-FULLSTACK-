package com.walmart.walmart.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class FlutterErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request) {
        // Get the original request URI
        Object originalUri = request.getAttribute("jakarta.servlet.error.request_uri");

        if (originalUri != null && originalUri.toString().startsWith("/api/")) {
            // For API errors, let Spring handle it normally
            return "forward:/error-api";
        } else {
            // For non-API routes, serve Flutter index.html for client-side routing
            return "forward:/index.html";
        }
    }
}