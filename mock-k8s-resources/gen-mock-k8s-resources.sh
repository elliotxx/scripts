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
  for i in {1..30}; do 
    cat <<EOF > "$output_dir/mock-$fruit-$i.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: mock-$fruit-$i
EOF

    cat <<EOF >> "$output_dir/mock-$fruit-$i.yaml"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mock-deployment-$fruit-$i
  namespace: mock-$fruit-$i
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mock-app
      fruit: $fruit-$i
  template:
    metadata:
      labels:
        app: mock-app
        fruit: $fruit-$i
    spec:
      containers:
      - name: mock-container
        image: nginx:latest
EOF

    cat <<EOF >> "$output_dir/mock-$fruit-$i.yaml"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mock-configmap-$fruit-$i
  namespace: mock-$fruit-$i
data:
  key1: value1
  key2: value2
EOF

    cat <<EOF >> "$output_dir/mock-$fruit-$i.yaml"
---
apiVersion: v1
kind: Secret
metadata:
  name: mock-secret-$fruit-$i
  namespace: mock-$fruit-$i
type: Opaque
data:
  username: dXNlcm5hbWU=
  password: cGFzc3dvcmQ=
EOF

    cat <<EOF >> "$output_dir/mock-$fruit-$i.yaml"
---
apiVersion: v1
kind: Service
metadata:
  name: mock-service-$fruit-$i
  namespace: mock-$fruit-$i
spec:
  selector:
    app: mock-app
    fruit: $fruit-$i
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF

    cat <<EOF >> "$output_dir/mock-$fruit-$i.yaml"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mock-ingress-$fruit-$i
  namespace: mock-$fruit-$i
spec:
  rules:
  - host: $fruit-$i.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mock-service-$fruit-$i
            port:
              number: 80
EOF
  done
done

echo "Mock resources generated in $output_dir"

