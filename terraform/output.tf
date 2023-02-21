output "vm1_name_external_ip" {
  value       = "${yandex_compute_instance.host1.name}: ${yandex_compute_instance.host1.network_interface.0.nat_ip_address}"
  description = "The Name and public IP address of VM1 instance."
  sensitive   = false
}
output "vm2_name_external_ip" {
  value       = "${yandex_compute_instance.host2.name}: ${yandex_compute_instance.host2.network_interface.0.nat_ip_address}"
  description = "The Name and public IP address of VM2 instance."
  sensitive   = false
}
output "vm3_name_external_ip" {
  value       = "${yandex_compute_instance.host3.name}: ${yandex_compute_instance.host3.network_interface.0.nat_ip_address}"
  description = "The Name and public IP address of VM3 instance."
  sensitive   = false
}
