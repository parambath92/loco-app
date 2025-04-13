# Build stage
FROM python:3.11-alpine AS build

WORKDIR /app
RUN mkdir -p /install
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --prefix=/install -r requirements.txt
COPY . .

# Final stage (Alpine for smaller image)
FROM python:3.11-alpine
RUN apk add --no-cache libffi libstdc++ 
ENV PYTHONPATH="/usr/local/lib/python3.11/site-packages"
RUN mkdir -p /usr/local/lib/python3.11/site-packages
COPY --from=build /install /usr/local
COPY --from=build /app .
EXPOSE 8080
CMD ["python", "/app/main.py"]
