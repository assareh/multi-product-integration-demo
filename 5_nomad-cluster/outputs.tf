output "nomad_sg" {
  value = aws_security_group.nomad.id
}

output "nomad_public_endpoint" {
  value = "http://${aws_alb.nomad.dns_name}"
}

output "bootstrap_kv" {
  value = vault_mount.kvv2.path
}

output "ssh_ca_pub_key" {
  value = vault_ssh_secret_backend_ca.ssh_ca.public_key
}

check "nomad_health_check" {
  data "http" "nomad_public_endpoint" {
    url = "http://${aws_alb.nomad.dns_name}"
  }

  assert {
    condition = data.http.nomad_public_endpoint.status_code == 200
    error_message = "${data.http.nomad_public_endpoint.url} returned an unhealthy status code"
  }
}
