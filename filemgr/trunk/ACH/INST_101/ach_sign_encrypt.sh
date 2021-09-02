#!/usr/bin/bash

# $Id: ach_sign_encrypt.sh 3197 2015-07-17 19:45:32Z bjones $

FILE="$1"

# for testing 20150715
#   removed -sign option
#
#   original command:
#
# gpg --no-tty --passphrase-fd 0 --sign --output "${FILE}.gpg" \
#     --encrypt \
#     --recipient 771CE99A "${FILE}" <<END
# bread&butter
# END

gpg --batch --armor --no-tty --passphrase-fd 0 --sign --output "${FILE}.gpg" \
    --encrypt --no-secmem-warning  \
    --recipient 8172972A "${FILE}" <<END
bread&butter
END
