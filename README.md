Google Speech Recognition in VitalPBX
=====
<iframe width="560" height="315" src="https://www.youtube.com/embed/QRCGawA45fE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

This script makes use of Google's Cloud Speech API in order to render speech
to text and return it back to the dialplan as an asterisk channel variable.

## Requirements<br>
Perl:               The Perl Programming Language<br>
perl-libwww-perl:   The World-Wide Web library for Perl<br>
perl-JSON:          Module for manipulating JSON-formatted data<br>
perl-IO-Socket-SSL: Perl module that implements an interface to SSL sockets.<br>

Cloud Speech API key from Google (https://cloud.google.com/speech).
Internet access in order to contact Google and get the speech data.

## Installation<br>
Install dependencies
<pre>
[root@vitalpbx ~]# yum install -y perl perl-libwww-perl perl-JSON perl-IO-Socket-SSL 
</pre>

Copy googleasr.agi to your agi-bin directory.
<pre>
[root@vitalpbx ~]# cd /var/lib/asterisk/agi-bin/
[root@vitalpbx ~]# wget https://github.com/VitalPBX/Google_ASR_VitalPBX/blob/master/googleasr.agi
[root@vitalpbx ~]# chown asterisk:asterisk googleasr.agi
[root@vitalpbx ~]# chmod +x googleasr.agi
</pre>

In order to use the Speech Recognition service it is necessary to obtain an API Key.

To obtain the API key go to google developer site (It is necessary to register, Google gives a trial of 1 year with US$ 300.00 credit)

https://console.developers.google.com

Go to Credentials/Create credentials and copy the Key.

Edit the googleasr.agi file and add the API key obtained in Google. Line 66.

<pre>
[root@vitalpbx ~]# cd /var/lib/asterisk/agi-bin/
[root@vitalpbx ~]# vi googleasr.agi
my $key = ""
Insert the key between the double quotes.
</pre>

## Usage<br>
agi(googleasr.agi,[lang],[timeout],[intkey],[NOBEEP],[rtimeout],[speechContexts])
Records from the current channel until 2 seconds of silence are detected
(this can be set by the user by the 'timeout' argument, -1 for no timeout) or the
interrupt key (# by default) is pressed. If NOBEEP is set, no beep sound is played
back to the user to indicate the start of the recording. If 'rtimeout' is set, 
overwrite to the absolute recording timeout. 'SpeechContext' provides hints to 
favor specific words and phrases in the results. Usage: [Agamemnon,Midas]
The recorded sound is send over to Google speech recognition service and the
returned text string is assigned as the value of the channel variable 'utterance'.
The scripts sets the following channel variables:

utterance  : The generated text string.
confidence : A value between 0 and 1 indicating the probability of a correct recognition.
             Values bigger than 0.95 usually mean that the resulted text is correct.

In case of an unexpected error both these variables are set to '-1'.

## Examples<br>
First, for this example to work, you have to install Google TTS with VitalPBX:
https://github.com/VitalPBX/Google_TTS_VitalPBX

<pre>
[cos-all](+)
;Simple speech recognition

exten => *277,1,Answer()
exten => *277,n,agi(googletts.agi,"After de beep say something in English, when done press the pound key.",en)
exten => *277,n,agi(googleasr.agi,en-US)
exten => *277,n,Verbose(1,The text you just said is: ${utterance})
exten => *277,n,Verbose(1,The probability to be right is: ${confidence})
exten => *277,n,agi(googletts.agi,"You said... " ${utterance},en)
exten => *277,n,Hangup()

;Voice dialing example

exten => *2770,1,Answer()
exten => *2770,n,agi(googletts.agi,"PLease say the number you want to dial.",en)
exten => *2770,n(record),agi(googleasr.agi,en-US)
exten => *2770,n,GotoIf($["${confidence}" > "0.8"]?success:retry)
exten => *2770,n(success),goto(cos-all,${utterance},1)
exten => *2770,n(retry),agi(googletts.agi,"Can you please repeat?",en)
exten => *2770,n,goto(record)
</pre>

## Supported Languages
"af-ZA" Afrikaans (Suid-Afrika)<br>
"id-ID" Bahasa Indonesia (Indonesia)<br>
"ms-MY" Bahasa Melayu (Malaysia)<br>
"ca-ES" Català (Espanya)<br>
"cs-CZ" Čeština (Česká republika)<br>
"da-DK" Dansk (Danmark)<br>
"de-DE" Deutsch (Deutschland)<br>
"en-AU" English (Australia)<br>
"en-CA" English (Canada)<br>
"en-GB" English (Great Britain)<br>
"en-IN" English (India)<br>
"en-IE" English (Ireland)<br>
"en-NZ" English (New Zealand)<br>
"en-PH" English (Philippines)<br>
"en-ZA" English (South Africa)<br>
"en-US" English (United States)<br>
"es-AR" Español (Argentina)<br>
"es-BO" Español (Bolivia)<br>
"es-CL" Español (Chile)<br>
"es-CO" Español (Colombia)<br>
"es-CR" Español (Costa Rica)<br>
"es-EC" Español (Ecuador)<br>
"es-SV" Español (El Salvador)<br>
"es-ES" Español (España)<br>
"es-US" Español (Estados Unidos)<br>
"es-GT" Español (Guatemala)<br>
"es-HN" Español (Honduras)<br>
"es-MX" Español (México)<br>
"es-NI" Español (Nicaragua)<br>
"es-PA" Español (Panamá)<br>
"es-PY" Español (Paraguay)<br>
"es-PE" Español (Perú)<br>
"es-PR" Español (Puerto Rico)<br>
"es-DO" Español (República Dominicana)<br>
"es-UY" Español (Uruguay)<br>
"es-VE" Español (Venezuela)<br>
"eu-ES" Euskara (Espainia)<br>
"fil-PH" Filipino (Pilipinas)<br>
"fr-FR" Français (France)<br>
"gl-ES" Galego (España)<br>
"hr-HR" Hrvatski (Hrvatska)<br>
"zu-ZA" IsiZulu (Ningizimu Afrika)<br>
"is-IS" Íslenska (Ísland)<br>
"it-IT" Italiano (Italia)<br>
"lt-LT" Lietuvių (Lietuva)<br>
"hu-HU" Magyar (Magyarország)<br>
"nl-NL" Nederlands (Nederland)<br>
"nb-NO" Norsk bokmål (Norge)<br>
"pl-PL" Polski (Polska)<br>
"pt-BR" Português (Brasil)<br>
"pt-PT" Português (Portugal)<br>
"ro-RO" Română (România)<br>
"sk-SK" Slovenčina (Slovensko)<br>
"sl-SI" Slovenščina (Slovenija)<br>
"fi-FI" Suomi (Suomi)<br>
"sv-SE" Svenska (Sverige)<br>
"vi-VN" Tiếng Việt (Việt Nam)<br>
"tr-TR" Türkçe (Türkiye)<br>
"el-GR" Ελληνικά (Ελλάδα)<br>
"bg-BG" Български (България)<br>
"ru-RU" Русский (Россия)<br>
"sr-RS" Српски (Србија)<br>
"uk-UA" Українська (Україна)<br>
"he-IL" עברית (ישראל)<br>
"ar-IL" العربية (إسرائيل)<br>
"ar-JO" العربية (الأردن)<br>
"ar-AE" العربية (الإمارات)<br>
"ar-BH" العربية (البحرين)<br>
"ar-DZ" العربية (الجزائر)<br>
"ar-SA" العربية (السعودية)<br>
"ar-IQ" العربية (العراق)<br>
"ar-KW" العربية (الكويت)<br>
"ar-MA" العربية (المغرب)<br>
"ar-TN" العربية (تونس)<br>
"ar-OM" العربية (عُمان)<br>
"ar-PS" العربية (فلسطين)<br>
"ar-QA" العربية (قطر)<br>
"ar-LB" العربية (لبنان)<br>
"ar-EG" العربية (مصر)<br>
"fa-IR" فارسی (ایران)<br>
"hi-IN" हिन्दी (भारत)<br>
"th-TH" ไทย (ประเทศไทย)<br>
"ko-KR" 한국어 (대한민국)<br>
"cmn-Hant-TW" 國語 (台灣)<br>
"yue-Hant-HK" 廣東話 (香港)<br>
"ja-JP" 日本語（日本）<br>
"cmn-Hans-HK" 普通話 (香港)<br>
"cmn-Hans-CN" 普通话 (中国大陆)<br>

## Security Considerations<br>
This script contacts Google servers in order send the recorded voice data and get back
the resulted text. The script uses TLS by default to encrypt all the traffic between
your PBX and Google servers so no 3rd party can eavesdrop your communication, but your
voice data will be available to Google under a not yet defined policy.

## Tiny version<br>
The '-tiny' suffixed scripts use the HTTP::Tiny perl module instead of LWP::UserAgent and
JSON::Tiny instead of JSON. This makes them a lot faster when run in small embedded systems
or boards like the Raspberry pi. They can be used as an in-place replacement of the normal
scripts and expose the same interface/cli args. To use them just make sure
you have HTTP::Tiny and JSON::Tiny installed.

## License<br>
The speech-recog script for asterisk is distributed under the GNU General Public
License v2. See COPYING for details.

## Authors<br>
Lefteris Zafiris (zaf@fastmail.com)

## VitalPBX Integrator<br>
Rodrigo Cuadra (rcuadra@vitalpbx.com)

## Homepage<br>
https://github.com/VitalPBX/Google_ASR_VitalPBX
