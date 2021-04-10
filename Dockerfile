FROM python:3.6

ENV SCENARIO_DOWNLOAD_URL https://hoge.com/locustfile.py

RUN pip install locust

RUN mkdir /locust
ADD ./master.sh /locust/master.sh
ADD ./slave.sh /locust/slave.sh
RUN chmod +x /locust/master.sh
RUN chmod +x /locust/slave.sh
RUN curl -L --silent ${SCENARIO_DOWNLOAD_URL} >  /locust/locustfile.py

CMD ["/locust/master.sh"]
