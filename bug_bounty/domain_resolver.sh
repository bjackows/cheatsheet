main() {
	domain=$1
	ip=$(dig A +short "${domain}" | head -n 1)
	[ "x${ip}" = "x" ] && { echo "${domain}"; return 0; }
	printf '%s\t%s\n' "${domain}" "${ip}"
}
export -f main
cat - | xargs -n1 -P20 bash -c 'main "$1"' _
