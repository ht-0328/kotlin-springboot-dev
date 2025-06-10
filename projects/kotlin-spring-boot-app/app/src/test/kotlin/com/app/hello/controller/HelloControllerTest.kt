package com.app.hello.controller
import com.app.hello.service.HelloService
import io.mockk.every
import io.mockk.mockk
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class HelloControllerTest {
    @Test
    fun `hello controller returns response from mocked service`() {
        val mockService = mockk<HelloService>()
        every { mockService.sayHello("テスト") } returns "メッセージ: テスト"

        val controller = HelloController(mockService)
        val response = controller.hello("テスト")

        assertEquals("メッセージ: テスト", response.body)
    }
}
