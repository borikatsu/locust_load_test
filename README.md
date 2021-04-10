# locust_stress_test
HTTP request load test container using locust

# How to use
Clone this repository.
```
$ git clone https://github.com/borikatsu/locust_stress_test.git your-project-dir
```

## Start Docker container
Start the container using the docker-compose command.
```
$ docker-compose up -d
```

## Edit locustfile.py
We have a sample file here.
~~~Python
class UserBehavior(TaskSet):
    @task(1)
    def post(self):
        self.client.post(
            url=os.environ['LOCUST_TARGET_PATH'] + "/post,
            headers={
                'content-type': 'application/json',
                'X-TOKEN': os.environ['X_TOKEN'],
            },
            json={
                "key": "value"
            }
        )

    @task(1)
    def get(self):
        param = "?key=value"
        self.client.get(
            url=os.environ['LOCUST_TARGET_PATH'] + "/get" + param,
            headers={
                'X-TOKEN': os.environ['X_TOKEN'],
            }
        )
~~~

## Create cluster on AWS ECS
