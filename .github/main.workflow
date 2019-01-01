workflow "build-and-deploy" {
  on = "push"
  resolves = ["deploy"]
}

action "resume-html" {
  uses = "./resume/"
  args = "json_resume convert --template=resume/custom_html.mustache --out=html --dest_dir=static resume/resume.yml"
}

action "resume-pdf" {
  uses = "./resume/"
  args = "json_resume convert --template=resume/custom_html.mustache --out=pdf --dest_dir=static/resume resume/resume.yml"
}

action "build" {
  uses = "docker://cibuilds/hugo:0.53"
  args = "hugo"
  needs = ["resume-html","resume-pdf"]
}


action "test" {
  uses = "docker://cibuilds/hugo:0.53"
  args = "htmlproofer public --empty-alt-ignore --disable-external"
  needs = ["build"]
}

action "deploy" {
  uses = "docker://cibuilds/aws:1.16.81"
  args = "aws s3 sync --acl public-read --sse AES256 public/ s3://cplee.org/"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  env = {
    AWS_REGION = "us-west-2"
  }
  needs = ["test"]
}