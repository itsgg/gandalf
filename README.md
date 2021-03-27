# Gandalf

A simple rack middleware based rate limiter for REST and GraphQL.

![Alt Text](./gandalf.gif?raw=true)

## Setup

```bash
brew install httpie
```

## Running

```bash
./start
```

## API

### 1. REST Calls

#### 1.1 List user

```bash
http get :9393/users
```

#### 1.2 Create user

```bash
http post :9393/users name="Ganesh Ganesh" email="me@itsgg.com"
```

#### 1.3 Delete users

```bash
http delete :#{PORT}/users
```

### 2. Graphql Calls

#### 2.1 List user

```bash
http post :9393/graphql query="query users { users { id, name, email } }"
```

#### 2.2 Create user

```bash
http post :9393/graphql query="mutation CreateUser(\$name: String\!, \$email: String\!) { createUser(name: \$name, email: \$email) { id, name, email } }" variables:='{ "name":  "Hello", "email": "hello@world.com" }'
```

#### 2.3 Delete users

```bash
http post :#{PORT}/graphql query='mutation DeleteUsers { deleteUsers { data } }'
```

### 3. Testing

Tweak the settings in gandalf.yml and try different operations like

```yaml
http:
  GET:
    "/users":
      limit: 1
      period: 5
      block_for: 5
  POST:
    "/users":
      limit: 1
      period: 5
      block_for: 5
  DELETE:
    "/users":
      limit: 1
      period: 5
      block_for: 5

graphql:
  query:
    users:
      limit: 1
      period: 5
      block_for: 5
  mutation:
    createUser:
      limit: 1
      period: 5
      block_for: 5
    deleteUsers:
      limit: 1
      period: 5
      block_for: 5
```

```bash
rake http:post
rake http:get
rake http:delete
rake graphql:post
rake graphql:get
rake graphql:delete
```

Example response

```bash
➜ rake graphql:get
http post :9393/graphql query='query users { users { id, name, email } }'
HTTP/1.1 200 OK
Content-Length: 385
Content-Type: application/json
X-Content-Type-Options: nosniff

{
    "data": {
        "users": [
            {
                "email": "chuck.medhurst@bode.co",
                "id": 12,
                "name": "Sheilah Hettinger DC"
            },
            {
                "email": "chuck.medhurst@bode.co",
                "id": 13,
                "name": "Sheilah Hettinger DC"
            },
            {
                "email": "isaac.collier@tromp-franecki.org",
                "id": 14,
                "name": "Estelle Feil"
            },
            {
                "email": "isaac.collier@tromp-franecki.org",
                "id": 15,
                "name": "Estelle Feil"
            },
            {
                "email": "pete.blanda@oconner.biz",
                "id": 16,
                "name": "Lorena Ondricka"
            }
        ]
    }
}



3:06AM gg rate-limit-plugin-example (master) ✗
➜ rake graphql:get
http post :9393/graphql query='query users { users { id, name, email } }'
HTTP/1.1 429 Too Many Requests
Retry-After: 20
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
```
