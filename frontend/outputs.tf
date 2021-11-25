output "app_url" {
  value = "https://${aws_amplify_branch.master.branch_name}.${aws_amplify_app.frontend_app.default_domain}"
}
