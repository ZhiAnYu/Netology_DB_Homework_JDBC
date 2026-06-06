package netology.HomeworkJDBC;


import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.stream.Collectors;

@Repository
public class OrderRepository {

    //для именованного запроса
    private final NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    private final String query;

    //конструктор для создания бина
    public OrderRepository(NamedParameterJdbcTemplate namedParameterJdbcTemplate) {
        this.namedParameterJdbcTemplate = namedParameterJdbcTemplate;
        this.query = read("query.sql");
    }

    //String sql="SELECT o.product_name FROM netology_homework.orders o JOIN netology_homework.customers c " +
    //        "ON o.customer_id = c.id WHERE LOWER(c.name) = LOWER(:name) LIMIT 1;";
    //String sql = read("query.sql");

    //метод добавлен из текста задания
    private static String read(String scriptFileName) {
        try (InputStream is = new ClassPathResource(scriptFileName).getInputStream();
             BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is))) {
            return bufferedReader.lines().collect(Collectors.joining("\n"));
        } catch (IOException e) {
            throw new RuntimeException("Не удалось прочитать скрипт: " + scriptFileName, e);
        }
    }

    // Выполняем запрос, передавая:
    // 1. Текст запроса из файла
    // 2. Map с именованным параметром "name", значение которого берем из аргумента метода
    // 3. Лямбда-выражение (RowMapper), которое явно указывает, как извлечь строку из результата
    public String getProductName(String name) {
        return namedParameterJdbcTemplate.queryForObject(
                query,
                Map.of("name", name),
                (rs, rowNum) -> rs.getString("product_name"));
    }
}
