terraform {
  backend "remote" {
    organization = "Anju_devops"

    workspaces {
      name = "Multi-DR"
    }
  }
}
