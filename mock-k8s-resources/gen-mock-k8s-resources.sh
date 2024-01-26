#!/bin/bash

output_dir="mock_resources"
rm -rf "$output_dir"
mkdir "$output_dir"

fruits=("apple" "banana" "orange" "grape" "kiwi" "mango" "pear" "cherry" "pineapple" "watermelon" 
        "lemon" "strawberry" "blueberry" "raspberry" "blackberry" "peach" "plum" "apricot" "nectarine" "pomegranate"
        "fig" "date" "kiwi" "passionfruit" "dragonfruit" "papaya" "guava" "lychee" "avocado" "coconut"
        "melon" "lime" "tangerine" "grapefruit" "cantaloupe" "apricot" "persimmon" "cranberry" "currant" "gooseberry"
        "kiwano" "starfruit" "elderberry" "boysenberry" "rhubarb" "tamarillo" "quince" "mulberry" "kiwifruit")


for fruit in "${fruits[@]}"; do
	  # 生成 Namespace 的 YAML 文件
	    cat <<EOF > "$output_dir/mock-$fruit.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: mock-$fruit
EOF

  # 生成 Deployment 的 YAML 文件
    cat <<EOF >> "$output_dir/mock-$fruit.yaml"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mock-deployment-$fruit
  namespace: mock-$fruit
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mock-app
      fruit: $fruit
  template:
    metadata:
      labels:
        app: mock-app
        fruit: $fruit
    spec:
      containers:
      - name: mock-container
        image: nginx:latest
EOF

  # 生成 ConfigMap 的 YAML 文件
    cat <<EOF >> "$output_dir/mock-$fruit.yaml"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mock-configmap-$fruit
  namespace: mock-$fruit
data:
  key1: value1
  key2: value2
EOF

  # 生成 Secret 的 YAML 文件
    cat <<EOF >> "$output_dir/mock-$fruit.yaml"
---
apiVersion: v1
kind: Secret
metadata:
  name: mock-secret-$fruit
  namespace: mock-$fruit
type: Opaque
data:
  username: dXNlcm5hbWU=
  password: cGFzc3dvcmQ=
EOF

  # 生成 Service 的 YAML 文件
    cat <<EOF >> "$output_dir/mock-$fruit.yaml"
---
apiVersion: v1
kind: Service
metadata:
  name: mock-service-$fruit
  namespace: mock-$fruit
spec:
  selector:
    app: mock-app
    fruit: $fruit
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF

  # 生成 Ingress 的 YAML 文件
    cat <<EOF >> "$output_dir/mock-$fruit.yaml"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mock-ingress-$fruit
  namespace: mock-$fruit
spec:
  rules:
  - host: $fruit.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mock-service-$fruit
            port:
              number: 80
EOF

done

echo "Mock resources generated in $output_dir"

