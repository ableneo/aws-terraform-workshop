resource "aws_amplify_app" "frontend_app" {
  name         = var.app_name
  repository   = var.git_repo
  access_token = var.git_access_token

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  environment_variables = {
    ENV = var.environment_name
    BACKEND_URL = var.backend_url
  }
}

resource "aws_amplify_backend_environment" "backend_env" {
  app_id           = aws_amplify_app.frontend_app.id
  environment_name = var.environment_name
}


resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.frontend_app.id
  branch_name = "main"

  framework = "React"
  stage     = "DEVELOPMENT"

}
