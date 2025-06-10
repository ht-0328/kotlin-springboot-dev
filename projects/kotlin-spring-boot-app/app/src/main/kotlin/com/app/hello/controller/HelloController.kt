package com.app.hello.controller

import com.app.hello.service.HelloService
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HelloController(
    private val helloService: HelloService,
) {
    @GetMapping("/hello", produces = [MediaType.TEXT_PLAIN_VALUE])
    fun hello(message: String): ResponseEntity<String> {
        val response = helloService.sayHello(message)
        return ResponseEntity
            .ok()
            .contentType(MediaType("text", "plain", Charsets.UTF_8))
            .body(response)
    }
}
