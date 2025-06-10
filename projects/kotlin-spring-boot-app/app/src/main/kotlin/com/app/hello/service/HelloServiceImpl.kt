package com.app.hello.service

import org.springframework.stereotype.Service

@Service
class HelloServiceImpl : HelloService {
    override fun sayHello(message: String): String = "メッセージ: $message"
}
