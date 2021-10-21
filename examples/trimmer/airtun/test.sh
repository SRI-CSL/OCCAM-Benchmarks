#!/usr/bin/env bash

echo "Test airtun"
./airtun-ng_occamized_stripped > t_out 2>&1 
./airtun-ng-orig -a 00:0c:29:52:aa:56 -w 1234567890 enp0s8 > o_out 2>&1 
echo "Output comparison to Baseline:" 
cmp -s ./t_out o_out; 
RETVAL=$?; \
if [ $RETVAL -eq 0 ]; then \
        echo "airtun test baseline compare? Passed!"; \
else \
        echo "airtun test baseline compare? Failed!"; \
fi
rm ./o_out
rm ./t_out

