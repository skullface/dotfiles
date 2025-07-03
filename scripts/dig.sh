#!/bin/bash
# from https://github.com/JacobMGEvans/dig-everything/blob/main/index.ts

if [ $# -eq 0 ]
then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

SUBDOMAINS=("accounts" "clerk" "clk._domainkey" "clk2._domainkey" "clkmail")

get_records() {
  local type=$1
  echo "Getting $type records for $DOMAIN..."
  result=$(dig +noall +answer $DOMAIN $type)
  if [ -z "$result" ]; then
    echo "No $type records found for $DOMAIN."
  else
    echo "$result"
  fi
}

get_records "A"
get_records "AAAA"
get_records "MX"
get_records "NS"
get_records "TXT"
get_records "SOA"

echo "Starting CNAME records for $DOMAIN..."

for SUB in "${SUBDOMAINS[@]}"; do
  echo "Checking CNAME record for $SUB.$DOMAIN..."
  cname_result=$(dig +noall +answer "$SUB.$DOMAIN" CNAME)
  if [ -z "$cname_result" ]; then
    echo "No CNAME record found for $SUB.$DOMAIN."
  else
    echo "$cname_result"
  fi
done

echo "Trace path packets for $DOMAIN..."
dig +trace $DOMAIN

echo "DNSSEC security extensions..."
dig +dnssec $DOMAIN

echo "Completed!"
