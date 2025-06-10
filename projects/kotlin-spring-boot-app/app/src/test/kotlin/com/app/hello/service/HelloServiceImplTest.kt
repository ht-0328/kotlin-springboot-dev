package com.app.hello.service

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class HelloServiceImplTest {
    private val helloService: HelloService = HelloServiceImpl()

    @Test
    fun `sayHello should return message with prefix`() {
        val input = "こんにちは"
        val expected = "メッセージ: こんにちは"
        val result = helloService.sayHello(input)
        assertEquals(expected, result)
    }
}
