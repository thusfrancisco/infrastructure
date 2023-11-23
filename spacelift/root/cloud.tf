resource "spacelift_stack" "cloud_root_role" {
  for_each = var.set_of_clouds

  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing the root role on ${each.value}."
  enable_local_preview = true
  labels               = ["${var.organization}-context-root-${each.value}"]
  name                 = "${var.organization}-stack-root-${each.value}_root_role"
  project_root         = "${each.value}/root-role"
  repository           = var.repository
  space_id             = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack" "cloud_root_organization" {
  for_each = var.set_of_clouds

  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing root-level ${each.value} infrastructure."
  enable_local_preview = true
  labels               = ["${var.organization}-context-root-${each.value}"]
  name                 = "${var.organization}-stack-root-${each.value}_root_organization"
  project_root         = "${each.value}/root-organization"
  repository           = var.repository
  space_id             = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "cloud_root_role-on-root" {
  for_each = var.set_of_clouds

  stack_id            = spacelift_stack.cloud_root_role[each.value].id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_stack_dependency" "cloud_root_role-on-cloud_root_organization" {
  for_each = var.set_of_clouds

  stack_id            = spacelift_stack.cloud_root_organization[each.value].id
  depends_on_stack_id = spacelift_stack.cloud_root_role[each.value].id
}
