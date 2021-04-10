from locust import HttpUser, TaskSet, task, between, constant
import os

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

class WebsiteUser(HttpUser):
    tasks = {UserBehavior:1}
    wait_time = constant(1)
