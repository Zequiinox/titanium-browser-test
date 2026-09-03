#!/bin/bash

# Chromium 152 disables NTP theme customization whenever the WebUI NTP
# override is enabled. Titanium's NTP override should not prevent users from
# selecting a local New Tab Page background, so remove only that guard.
NTP_UTILS="chrome/browser/ntp_customization/java/src/org/chromium/chrome/browser/ntp_customization/NtpCustomizationUtils.java"

if [ -f "$NTP_UTILS" ]; then
    python3 - "$NTP_UTILS" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()

text = text.replace(
    'import static org.chromium.chrome.browser.url_constants.UrlOverrideUtils.isWebUiNtpOverrideEnabled;\n',
    ''
)
text = text.replace(
    '''        if (isWebUiNtpOverrideEnabled()) {\n            return false;\n        }\n\n''',
    ''
)

path.write_text(text)
PY
fi
