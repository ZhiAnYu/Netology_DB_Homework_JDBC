package netology.HomeworkJDBC;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OrderController {
    private final OrderRepository orderRepository;


    public OrderController(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @GetMapping("/products/fetch-product")
    public ResponseEntity<String> fetchProduct(@RequestParam String name) {
        try {
            // Вызываем метод репозитория
            String productName = orderRepository.getProductName(name);

            // Если всё успешно, возвращаем HTTP 200 OK и название продукта
            return ResponseEntity.ok(productName);

        } catch (EmptyResultDataAccessException e) {
            // Если записей не найдено, возвращаем HTTP 404 Not Found
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Продукт для пользователя '" + name + "' не найден");

        } catch (Exception e) {
            // На случай любых других непредвиденных ошибок (например, проблема с БД)
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Произошла внутренняя ошибка сервера");
        }
    }
}
