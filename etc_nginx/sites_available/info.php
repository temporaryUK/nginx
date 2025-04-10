location /info.php {
        proxy_pass http://127.0.0.1:8080/info.php;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
