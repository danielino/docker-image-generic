FROM hashicorp/terraform:1.6.6 as terraform-builder
FROM hashicorp/packer:light as packer-builder

FROM alpine:3.18

COPY --from=terraform-builder /bin/terraform /bin/terraform
COPY --from=packer-builder /bin/packer /bin/packer

COPY requirements.txt /tmp/requirements.txt

RUN apk update && \
    apk add gcc musl-dev linux-headers libffi-dev \
            python3 python3-dev py3-pip git jq bash && \
    pip3 install -r /tmp/requirements.txt

RUN adduser -u 1001 jenkins -s /bin/bash -D && \
    mkdir /workspace

WORKDIR /workspace

USER jenkins

CMD ["/bin/bash"]
