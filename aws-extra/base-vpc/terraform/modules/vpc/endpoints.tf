resource "aws_vpc_endpoint" "private_s3" {
	vpc_id = "${aws_vpc.vpc.id}"
	service_name = "com.amazonaws.us-west-2.s3"
	route_table_ids = [
		"${aws_route_table.private.*.id}",
		"${aws_route_table.public.*.id}"
	]
}
