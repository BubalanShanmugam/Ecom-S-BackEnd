package com.example.e_commerce.Controller;

import com.example.e_commerce.Model.Product;
import com.example.e_commerce.Service.ProductService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
//import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@CrossOrigin(origins = "http://localhost:5173")
@RestController
@RequestMapping("/api")
public class ProductController {

    @Autowired
    private ProductService service;

    @GetMapping("/products")
    //ResponseEntity - By doing this we not only have data also respond entity. we have status
    public ResponseEntity<List<Product>> getAllProducts() {

        return new ResponseEntity<>(service.getAllProducts(), HttpStatus.OK);  //service get the product from DB
    }

    @GetMapping("/product/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable int id) {
        Product product = service.getProductById(id);
        if(product != null)
            return new ResponseEntity<>(product, HttpStatus.OK);
        else
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
    }

    @PostMapping("/product")
    //? - accept the response and exception(both)
    //@RequestPart - it will accept an part
    public ResponseEntity<?> addProduct(@RequestPart("product") String product, @RequestPart("imageFile")  MultipartFile imageFile) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            Product produc = mapper.readValue(product, Product.class);
            System.out.println(product);
            Product product1 = service.addProduct(produc, imageFile);

            return new ResponseEntity<>(product1, HttpStatus.CREATED);
        } catch (Exception e) {
            e.printStackTrace();
           return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("product/{productId}/image")
    public ResponseEntity<byte[]> getImageByProductId(@PathVariable int productId) {
    Product product = service.getProductById(productId);
    byte[] imageFile = product.getImageData();
    return ResponseEntity.ok().contentType(MediaType.valueOf(product.getImageType())).body(imageFile);
    }

    @PutMapping("/product/{id}")
    public ResponseEntity<String> updateProduct(@PathVariable int id,
                                                @RequestPart Product product,
                                                @RequestPart MultipartFile imageFile){
        Product product1;
        try {
            product1=service.updateProduct(id,product,imageFile);
        }catch (Exception e){
            return new ResponseEntity<>("Failed to update", HttpStatus.BAD_REQUEST);
        }

        if (product1 != null){
            return new ResponseEntity<>("Updated", HttpStatus.OK);
        }
        else{
            return new ResponseEntity<>("Failed to update", HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/product/{id}")
    public ResponseEntity<String> deleteProduct(@PathVariable int id){
        Product product=service.getProductById(id);
        if(product!=null){
            service.deleteMapping(id);
            return new ResponseEntity<>("Deleted", HttpStatus.OK);
        }
        else{
            return new ResponseEntity<>("Failed to update", HttpStatus.NOT_FOUND);
        }
    }
    @GetMapping("/products/search")
    public ResponseEntity<List<Product>> searchProducts(String keyword) {
        System.out.println(keyword);
        List<Product> Products = service.searchProducts(keyword);
        return new ResponseEntity<>(Products, HttpStatus.OK);
    }
}
