workflow "build-and-deploy" {
  on = "push"
  resolves = ["deploy"]
}

action "info" {
  uses = "docker://ubuntu:18.04"
  args = "ls -alFtR"
}

action "build" {
  uses = "docker://cibuilds/hugo:0.53"
  args = "hugo -v"
  needs = ["info"]
}

action "test" {
  uses = "docker://cibuilds/hugo:0.53"
  args = "htmlproofer public --empty-alt-ignore --disable-external"
  needs = ["build"]
}

action "deploy" {
  uses = "docker://cibuilds/aws:1.16.81"
  args = "aws s3 sync --acl \"public-read\" --sse \"AES256\" public/ s3://cplee.org/"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  env = {
    AWS_REGION = "us-west-2"
  }
  needs = ["test"]
}
