# base64url.tcl --
#
#       Implementation of the URL-safe Base64 variant described
#       in section 5 of RFC 4648.
#
# Copyright 2020 Neil Madden.
# See the file LICENSE.txt for license terms.

package require Tcl         8.6
package provide base64url   1.0.0

namespace eval ::base64url {
    namespace export encode decode
    namespace ensemble create

    proc encode data {
        regexp {[^=]*(=*)} [binary encode base64 $data] -> padding
        string map {+ - / _ = ""} [binary encode base64 $data]
    }

    proc decode str {
        binary decode base64 [pad [string map {- + _ /} $str]]
    }

    proc pad str {
        return $str[padding $str]
    }

    proc padding str {
        string repeat = [expr {(4 - [string length $str]) & 3}]
    }
}

if 0 {
    set in [open /dev/urandom rb]
    for {set i 0} {$i < 1000} {incr i} {
        set data [read $in $i]

        # Test round trip
        set test [base64url decode [base64url encode $data]]
        if {$data ne $test} { puts "FAIL: [binary encode base64 $data]" }

        # Test padding
        regexp {[^=]*(=*)} [binary encode base64 $data] -> expectedPadding
        set padding [base64url::padding [base64url encode $data]]
        if {$padding ne $expectedPadding} {
            puts "FAIL: $padding != $expectedPadding ([binary encode base64 $data])"
        }
    }
    close $in
}
