; This is a very dirty hack to make your binary smaller. It's disgusting but beautiful. Don't try this at home.
; Credits for this hack: https://nathanotterness.com/2021/10/tiny_elf_modernized.html

[bits 64]

file_load_va: equ 4096 * 40

db 0x7f, 'E', 'L', 'F'
db 2
db 1
db 1
db 0
dq 0
dw 2
dw 0x3e
dd 1
dq _start + file_load_va
dq program_headers_start
; Section header offset. We don't have any sections, so set it to 0 for now.
dq 0
dd 0
dw 64
dw 0x38
dw 1
; Size of a section header entry.
dw 0x40
; Number of section header entries. Now 0, since we don't have them.
dw 0
; The section containing section names. Not used anymore, so set to 0.
dw 0

program_headers_start:
dd 1
dd 5
dq 0
dq file_load_va
dq file_load_va
; We'll change our single program header to include the entire file.
dq file_end
dq file_end
dq 0x200000


_start:
	mov rdi, file_load_va + input_str
	xor rax, rax
	push rax
.loop:
	call parse_line
	; 1 2 in rax
	mov rdi, rax
	call calculate_value
	pop rcx
	add rcx, rax
	push rcx 
	mov rcx, 10 << 16
	mov rax, rdi
	add rax, rcx
	mov rdi, rbx
	inc rdi

	mov rax, file_load_va + input_str
	add rax, input_len
	cmp rax, rdi
	jg .loop
	pop rdi
	call print_int
	call exit

calculate_value:
	push rbx
	mov rbx, rdi
	xor rax, rax
	mov al, bh
	sub rax, 48
	xor rcx, rcx
	mov cl, bl
	sub cl, 48
	imul rcx, rcx, 10
	add rax, rcx
	pop rbx
	ret

parse_line:
	call forward_search
	push rax
.loop:
	cmp BYTE [rdi], 10
	je .newline	
	inc rdi
	jmp .loop
.newline:
	push rdi
	mov rax, rdi
	call backwards_search
	pop rbx

	shl rax, 8
	mov al, BYTE [rsp] 
	pop rcx
	ret

forward_search:
	xor rax, rax
	dec rdi
.loop:
	inc rdi
	mov al, BYTE [rdi]
	cmp al, 48 ; '0'
	jl .loop
	cmp al, 57
	jg .loop
	ret

backwards_search:
	xor rax, rax
	inc rdi
.loop:
	dec rdi
	mov al, BYTE [rdi]
	cmp al, 48 ; '0'
	jl .loop
	cmp al, 57
	jg .loop
	ret
	
print_str:
	mov rdx, rsi
	mov rsi, rdi
	mov rax, 1
	mov rdi, 1
	syscall
	ret

print_int:
	mov rbx, rdi
	mov rdi, 10
	mov rcx, 1
	push 10
.loop:
	cmp rbx, 0
	jne .cont
	jmp .done
.cont:
	inc rcx
	mov rax, rbx
	xor rdx, rdx
	div rdi
	mov rbx, rax
	add rdx, 48
	pop rax
	shl rax, 8
	mov al, dl
	push rax
	jmp .loop
.done:
	mov rdi, rsp
	mov rsi, rcx
	call print_str
exit:
	mov rax, 60
	mov rdi, 1
	syscall
code_end:

input_str db  "sq5fivetwothree1", 0xa, "six5gc", 0xa, "txb3qfzsbzbxlzslfourone1vqxgfive", 0xa, "3onethreebrth", 0xa, "cseven7nqqxnkzngndtddfiverkxkxqjjsr", 0xa, "2lvpmzh4", 0xa, "threeqxqndvjrz15", 0xa, "threetwo1drtzsixtwofourppvg", 0xa, "zxhsndseven2vbnhdtfpr3bt86", 0xa, "onethreelqqqqvj7eightnine5", 0xa, "7sevenfour5gnine", 0xa, "1seven5", 0xa, "vgxhqfrvr7vfsxqms3", 0xa, "twokdkcbhtqxfc87rkgctwo", 0xa, "twosix9threernltgbffour", 0xa, "npvzzqfb5tbbn4cnt", 0xa, "jjxlckssjmdkm5szklnq1two", 0xa, "lblcscglvseven53251zzcj", 0xa, "threesevenzplpzlqb1", 0xa, "threeeightxhrkflkbzp2", 0xa, "honemkmbfbnlhtbq19twonekbp", 0xa, "vdttwoeight7eightoneone6vq", 0xa, "eightvszlvntpfourjqcgmjr3", 0xa, "dslqnmd7k1twogbvhhnfmtsix", 0xa, "twocsnn7jslpsppxmjr36eightss", 0xa, "7eightrdcz74twolvd2cctg", 0xa, "4threerrqxpmmzhrqht4two2", 0xa, "2seven9two", 0xa, "479", 0xa, "threefour86", 0xa, "5klxgb1", 0xa, "dchrpzkfpgqzgjmpdcthreeeightsix82five", 0xa, "seven5tcls", 0xa, "six5three2six888zd", 0xa, "75nine274sbzd", 0xa, "seven7691dzflbg7seven", 0xa, "bjtrrvpx954lxr1qlqdvbldpt", 0xa, "zthree4", 0xa, "sixfourfour68", 0xa, "fourrjgvksixtwongbvkpff9", 0xa, "3seventwo", 0xa, "bzqqjtqvfssevenonenqzctcgbch9three5", 0xa, "4fourseventhreeck", 0xa, "mx5njh2", 0xa, "1onebqkdcbmvrknghnn5frdjtrq", 0xa, "one1nineflfp957vkdgfrjtfive", 0xa, "7eight7fiveeight", 0xa, "zzxrsrp313", 0xa, "1sixcksrxn4", 0xa, "ggqvtwofrrfdhbsdfdpzpbjjckbrg5ninebqszf", 0xa, "pxjcgc2ggqscglhjpbpr6seven", 0xa, "sixsix7twofivexgdm", 0xa, "four4eightseventjsqlbhrzvsevenfivesix3", 0xa, "twotwo8chjmb", 0xa, "dknnleightmmmmrmcrnr8", 0xa, "twogzdgdqhrs3836", 0xa, "ninebsztzhbqjvlbvhdktqjc6hpqcksfive6", 0xa, "twofive1nqdxdvvtvf4oneone2two", 0xa, "1eight8nkmhcfvzn", 0xa, "dzmkzzx4lfljtzp95seven4qqnpjdtr", 0xa, "one7sevenninepsdgrjkxgdchjtxrx", 0xa, "fnltdcxqln314nine7n", 0xa, "three7sjgtnxgtllnpndfourfiveseven4", 0xa, "64snine7", 0xa, "ppjlpsnsbmthfivelffive59hsnmn2", 0xa, "sevenqftktpnj6", 0xa, "ninethreetbgprvchxlnmfs3fourhmcz", 0xa, "xhl1", 0xa, "4qgf", 0xa, "1qbhrmfcffivedgtfour", 0xa, "eight86bcqskslkvlgone7gg", 0xa, "6pccldrtmsdbbrcbcq86", 0xa, "ppzrxtsix94jplxff11", 0xa, "786seventwoonezvnqrsix", 0xa, "7threeseventsjcdr", 0xa, "fivebfive3nineffcbzprh", 0xa, "4glxskdkjn", 0xa, "n8", 0xa, "kzcvdtbq49", 0xa, "7xvqxmhcfkkffnine93", 0xa, "hhzmdnzktbtwojvlckvjsixeightone9rxqb", 0xa, "one3sqckgps8", 0xa, "lscdfp8eightcgdvgssveightdldsreight", 0xa, "jhjsltwoeight1one", 0xa, "6trxnfcqdmlrmf3three", 0xa, "one1kdclsglmsjmczsksdfour", 0xa, "sevensevenshlhsvtl8three", 0xa, "four522sevenfourcrthhhvkj", 0xa, "197stxphm8", 0xa, "8sixtwoseven6five", 0xa, "zjdhldjcqctkltggninesl6stplglmkn", 0xa, "6onesixrhmjvtcmbh", 0xa, "fivehnj8dninefourfive3", 0xa, "4fourfncsrhf73", 0xa, "nbcjqhlckonemdbcsvfsixvm3one", 0xa, "7seven6seven", 0xa, "fournfive6four9", 0xa, "6brzhdxzmtxfoureightxg6onetwo", 0xa, "5sixmmddqgpdnq4", 0xa, "6ndzzhlrdjxjqfxvss", 0xa, "gkvoneight29two", 0xa, "4threethree", 0xa, "eightsznbxf8fiveninetwo9vgfbv", 0xa, "8kzkmqncfhssjblmfd7hdmpkghsz9mmbsbjdxdlfmnxfour", 0xa, "four2threeeight19bx", 0xa, "1oneseven", 0xa, "fh5", 0xa, "615zkzg", 0xa, "25six2mrtjthree", 0xa, "jvvmbfzr3seven7xjbhvvvhlz38ninejk", 0xa, "vzjthjkrcc5six3rrnrseven", 0xa, "rjthree3szfourbnvnbh7hgjzcrhfptmlghkk", 0xa, "tgjtdsnqrq39seven3hgqc9", 0xa, "1vttzfour9", 0xa, "6vbtcqmpk213sixzmjcnxn9qhdgr", 0xa, "3sffvspzmxjjfourjxjbbdfj5", 0xa, "bdhj9lz1np7tvmfvptffhfdtbxld", 0xa, "kbkxldln99onetwoseven3", 0xa, "rvsthree9seven4seventwo", 0xa, "32zbjmhr", 0xa, "eightfffkdgjqspgzmkvzxpls4one", 0xa, "three1kxqr21ninemhrmheightwoc", 0xa, "fqjvtsph8zpghgdbxrg4", 0xa, "398seven", 0xa, "bnine1two5756", 0xa, "7xkqkxjjvmd2n77", 0xa, "9seven79foursxdqcvttwo", 0xa, "6d6zfxcmrzsixgmlqnfdn", 0xa, "kfhreightfnhcxpcrz9hqrqtmknpjxrt4hrk", 0xa, "seventhreeoneone4nngnlz37", 0xa, "fphhxfs8jzkchp8twotjznmlxhht", 0xa, "474", 0xa, "58eightnzxfgndgdvbvphzsqxqcffdqsvxtwo", 0xa, "3two5xvjjthreetmszrldjlknq", 0xa, "1nine7", 0xa, "29kfrrdxvrmgjvfpqjcqlplfhrxpklzcrvndmdhjhninejhmph4", 0xa, "fzbq39bs", 0xa, "85eight29fiveccsrvsixfive", 0xa, "sggksrnseven28ninesixnine", 0xa, "bggkmnrbjknxqfgttxsixnine4", 0xa, "73nfive", 0xa, "fivefourgscsevencntfpzzrnineprdjqdbmq5", 0xa, "6four2oneeightljstfshztx9", 0xa, "sevenzkdqst6jncvcblb", 0xa, "dxrnzlsix5", 0xa, "two1tmhmg4four", 0xa, "2mzfnc5threefourthreesixfivezq", 0xa, "jeightwo3jfzqdtjzschpzrj2", 0xa, "5ccchkjzvqh7", 0xa, "jdpnjqg3five48xmmptkzmvg", 0xa, "rgn146nineseven4six", 0xa, "eightonetwohsxms8six94", 0xa, "eight4znfqgsftghtrhfkvj", 0xa, "btmk5834eight8mlcccnrzrb", 0xa, "15ninemhmhmqlb", 0xa, "85skmrvhl74", 0xa, "dbvhkthj4", 0xa, "one6keight", 0xa, "sixfourtwosevennine7tfrqgk8five", 0xa, "seven1kxcqbm1", 0xa, "tmpl56rz27qfdfour", 0xa, "3eightggcjbnktmbqfivefdmczl", 0xa, "b2threethreemnxdhrzsxqhchzbnvhppdcqcffour", 0xa, "htpgc4blggnnzts3four7", 0xa, "8sixbdntsg33njhtnsnsix", 0xa, "fourfour5seven3threesevensix", 0xa, "78eightsevenone", 0xa, "four5threefive", 0xa, "cjqbcfjnbf2six", 0xa, "five9ninesixonejdnsvcfive", 0xa, "rvrf9cjl3eightfvrzpjnxr", 0xa, "threeseven5", 0xa, "vxvmpkffrtwo9twofivesix", 0xa, "67xnrcxsp9rk", 0xa, "mvzdgqgrv77", 0xa, "one42qkfp", 0xa, "1vtq", 0xa, "225eightworbm", 0xa, "three9onefive", 0xa, "qxoneighteightzxlfksc3oneeight2", 0xa, "mnqjhg6ffbhzcsixtrbfr744zlg", 0xa, "8nine7", 0xa, "fivergqn2seven", 0xa, "44gpslt6nine6", 0xa, "1six98fsgthctwoseven", 0xa, "ldrqsbjrtnlj6lqgptgplbsnhrhpsixzqgpzkxone", 0xa, "7knxhcfjvshqsxsqrponeightld", 0xa, "zsixsjbltfournzndqbqd2rone", 0xa, "qpnvkqmdthree3234ninefour4", 0xa, "cdnhqqxxp2two6six", 0xa, "five9354xnbjjx", 0xa, "9eightsix4jjjeighttprrhqvqlt5", 0xa, "lkcfmvtonexklgknxxsglcd5znseventwo", 0xa, "four31nine56pmh", 0xa, "eight96tb5t2nineoneightrlb", 0xa, "fourncvgmslx695twobdklqzfour", 0xa, "8fiveq75four", 0xa, "5six9fourfour59seven1", 0xa, "eight2bqtqdjsvkkjfive81vpkvmbpxcp", 0xa, "nvxvgqhfouronefive4sixpqckgf", 0xa, "25onetwotwo", 0xa, "seventhreezkntcmjqeight493three9", 0xa, "ptd58qrtfqj", 0xa, "2985lvlvlrfzrjmfqbrmgtonejxtgpspjnx2", 0xa, "6qbzxqvx", 0xa, "three81btcngfkjj28seven", 0xa, "36six8", 0xa, "5gzthcpffr2", 0xa, "6kqtntqrzxsgksevengnzthree33", 0xa, "87fmnvqpczzhone5seven", 0xa, "nine2cxpmrhp", 0xa, "vt46xflbjdkkb7seven", 0xa, "eightrgthreethree98fourhgcqjgzclc", 0xa, "5nfsbcvmfv484fxjtwothreefive", 0xa, "nhvcn4glfxtkfttthree", 0xa, "6five9qznggpkflhzht7zhjjone", 0xa, "ddzghtvmp78five4gzfnnkc", 0xa, "sflvnzkrjtonenplrbkzxmt9fhfdzxrfjrtwomctkrlkhghfpcmkn7", 0xa, "sjxspdjhg96three112jz", 0xa, "xdbgzlfour2twosevenzfdtvxq6", 0xa, "gdtnt2fivelscmsix", 0xa, "9threefkjkrskxrcjsbthree", 0xa, "ninepmqbdmlkrmfhpgsz3twothree", 0xa, "onebgtdg5mqrfxvnfkseven", 0xa, "6m949fivezthrbbkqfd", 0xa, "2five94threeone", 0xa, "eight8four42vb", 0xa, "2ninetwo", 0xa, "17two9nine", 0xa, "3pdmsixfouronethreesixfiveb", 0xa, "five1two5", 0xa, "nine4four", 0xa, "three5lktjmlnbph", 0xa, "eight6onelrdlsevenj1zmmbtjrd", 0xa, "tkjhgvnpkvgsqzjrnine2hltwotwo", 0xa, "89xfpxgdlcpznxxfnpbzbzseven", 0xa, "293threej7four94", 0xa, "v63", 0xa, "pxccbml6sixhqnhmrfive", 0xa, "kddsix4fouronevtrgbvtxxxsix3one", 0xa, "5bxqjkdhthree", 0xa, "six4threezgg2", 0xa, "fourtwoeightmftwo99", 0xa, "t7ninenineeighteight8", 0xa, "5xvvlnqkjs4", 0xa, "seven7one", 0xa, "vqfhpk7hnthreeseven42", 0xa, "7threef2two92", 0xa, "2onefourckbrvqzq9", 0xa, "tvvdxrvthree2", 0xa, "seven1fourbvmfzftwortnjd16", 0xa, "pmttpsggb134mlffcsnbftwox1", 0xa, "2dzpvqtcxjfour5pgppvbk", 0xa, "9jfscbjzq", 0xa, "fiveninefivethreexdtgnbdfp5onefive", 0xa, "six1927", 0xa, "one1xjjkvkkfk1zxxrjhkg3sixmhcgc", 0xa, "7fivetnncl5", 0xa, "zbqzdkkthreekzdcbhpveightfourfivemrmpzv3", 0xa, "twothree51three2phhmrnnhntnine", 0xa, "bfzzqmthtgthree4sjzkmtrnplbxeight2eighthj", 0xa, "nqsflrlmlthreemdzztlghgj5xcj", 0xa, "fdtflsqrxltwohcvsnrndmsixeight7", 0xa, "fourbmlftwo2mzz8", 0xa, "pjjqzmsx4ksix", 0xa, "six1219one6seven1", 0xa, "gthznkpp31", 0xa, "nine4four32", 0xa, "xktzkqmmxct6fkhpkg", 0xa, "one5688sevenvjjthreefsvxt", 0xa, "36twonine", 0xa, "3fpdqtzrd3tslzgkjzxd5", 0xa, "bsevendpvtmnzl9cqgjfjbzfv222", 0xa, "lxbhkf2nseven79", 0xa, "gqckmfeightnknineeightsix45four", 0xa, "n78", 0xa, "42nggdthree4threefsxgjsixjdnqzkxdb", 0xa, "gbfbpjcjnzjrrqmm17473", 0xa, "1eightzqxxnq", 0xa, "25twovmnltzx", 0xa, "seveneight9qtcvzvmone138v", 0xa, "msixjrqprlnqhdfourjdmsddzseven85", 0xa, "eightninevvcp2", 0xa, "mtvvjsck6hgkjml", 0xa, "121fthreethree", 0xa, "jncgfj3eightr6", 0xa, "468four6xdlrgngbhcxbtf", 0xa, "3nqqgfone", 0xa, "1zmzjqscfournzbssixeighthmspdbhlpc4", 0xa, "twoonejmkb8sevenfourseveneightsix", 0xa, "qxrznqone8z8sevenninesixsc", 0xa, "jrklnh6threeone", 0xa, "2xfnbrk6frzsvjhb5sixeight", 0xa, "ninethree8lbpmqhsppd9fht2ninefql", 0xa, "7bzcnthreejdh7oneightj", 0xa, "155twofourthreemfive", 0xa, "5ninerm", 0xa, "9lxrfoursixm", 0xa, "glvxvsbsg7", 0xa, "jbrbhzrsftwofour1", 0xa, "two4hkxztgbbgf4ptckpggkbvvj7", 0xa, "vhqhqghjscvc3rcgttfv", 0xa, "ninetwo9threemhtsn", 0xa, "cnxzthgqz6pxfbsmkmm", 0xa, "45jgrr4ninetwo88", 0xa, "dkhgscrthreeeightsevenhsxjhr6five", 0xa, "6nine7vpfbvlvdvzvj", 0xa, "goneg4threeeightslhlzkpqv2", 0xa, "sjqgqz8oneglvzn", 0xa, "crj32neighttvv5", 0xa, "blqptxbggl6three1two46cbdzt", 0xa, "vpxnvxkgdmggpnine61", 0xa, "22kxn", 0xa, "5zvsmtzqjhhmfsvv4", 0xa, "dkfknfnjxtzjrbfk1", 0xa, "67sixzns61sdrpsmjsrftkdgjlb", 0xa, "6lnffcgtxfivesevenseven8", 0xa, "px1one96slxflxdfxhninehkcszmdxzbbjmlq", 0xa, "3sixsevenseven7vlvdlcjhccvmlzcn", 0xa, "5frrqhseventftbln6", 0xa, "three23seven7sixv", 0xa, "ninehscrb9", 0xa, "fivepvsxqmnbmvgphsevencgkhsnqkz1rxvg8", 0xa, "pbhsqvdxhf694six66", 0xa, "four2nineczdtwobjxkfnkbg", 0xa, "nineml1jbnm6vhpsgmdq2", 0xa, "three63vgbm", 0xa, "665", 0xa, "htd7pvmrpptvtneightnzmngone7", 0xa, "rfeightgrfffksdfmgclspbp7489", 0xa, "4fdxcnbfjtbfg63ninefivegkmhgz", 0xa, "21eight7one39", 0xa, "foursix8vrzhm", 0xa, "two8sevendneight", 0xa, "tncdggvfivekmbljttwo94fivetpstp7", 0xa, "68seven", 0xa, "onenxh9eightone", 0xa, "twothree3threenine4oneightzkr", 0xa, "onetwosixeightkfxnfnssd5", 0xa, "eightthree63five8", 0xa, "6seven7one", 0xa, "mqkkhbrjjm8v4", 0xa, "8six2", 0xa, "threetvbonethreeqmpkxjqlqgghqrlh5sbf3", 0xa, "blrnd9dkqgjf", 0xa, "41onervcmkgnpcbx52", 0xa, "frmdcps8sixtwo4ninefbdjfour2", 0xa, "8nineninenine", 0xa, "pkrln2dfrkkntwoonefjsfgx6", 0xa, "xvrkcmfxpfourfourrxcxqmhfour29ftsfd", 0xa, "crkmrlrb4fourthreeeightcgk", 0xa, "7threemrss4eightsevenskjh", 0xa, "eightsixqppfhv3ztn", 0xa, "3threeeightseven5", 0xa, "gkrfhthr12threeeightthree", 0xa, "8vthczh1", 0xa, "seven6hfcfmrlkmqxpjq9eightlvlgqmf", 0xa, "fivednzg85eightseveneightfive", 0xa, "dz8ssixkbbtgv", 0xa, "rdmjrcgeight6r", 0xa, "five6nineonesixrlnhj", 0xa, "zh127four7two", 0xa, "six1sevenvmlnvkgcldsrrblfbrphrfsx", 0xa, "m584sixkgng7bzzpzjzbfzqpgdcn", 0xa, "2twozmvzzjbpdftm186eight", 0xa, "twoninekvspfvkbxtkc3", 0xa, "fourrchgqkxfdzfccppqtpffhrtfive7seven7", 0xa, "four483eight", 0xa, "threelqlc7", 0xa, "xkgntdjninenine8brkjfsrttnineseven", 0xa, "9zkds", 0xa, "twostmdvsbflvqbdgfs55", 0xa, "twobnzn1czdfpns", 0xa, "5onetwo5", 0xa, "txsflrhgklnctfzrlgmplr8pdxl", 0xa, "93four882mgqmqnsnx", 0xa, "sevenfxschslsncjgqsctnineonenine1", 0xa, "brb9", 0xa, "7five9", 0xa, "three425", 0xa, "mkfone4ninefour", 0xa, "bkpdhbvq7", 0xa, "dhrlbjvcgqdtqjlk4zxzjpvdfm", 0xa, "67threefive", 0xa, "nineninegvmlfthreevtndnb9", 0xa, "ttmznl3fjdcbch", 0xa, "fqsxkm9nineoneh761", 0xa, "sixfivesixnjrtqdkqpc2xdhlrrmp", 0xa, "eightsix793nvdvbtxxksix", 0xa, "5veighteightgscktfbtd513", 0xa, "vfvrcknfls5q", 0xa, "7seven24rfpzpftrkgthree43", 0xa, "qplqnt4threezldtjfdzv", 0xa, "three1ghfglcthreecnzjjphgrlmone", 0xa, "eightthree84", 0xa, "xxtpxgonethree5", 0xa, "3onengztdjljx", 0xa, "cjrtxxlcpfcqjmgqknineseven2", 0xa, "sfxhqftcdht4eightthree", 0xa, "2plnnlkqjnfxv", 0xa, "ninenineeightone4brmgnngchf", 0xa, "fivexbtndsonesixlvtjvxhl4sixstn", 0xa, "dqcztwo8fourninexm", 0xa, "5532threeqmctrbnnhk", 0xa, "two4pqsjlcfone8jpt", 0xa, "onefour42jqs2", 0xa, "4eightone3gvqfhmmrnprc", 0xa, "6sjlcfbs8fourfourfiveseven", 0xa, "nfdeightwo31threeoneeighthjnvcddclm", 0xa, "149two", 0xa, "8ckgmfsp32zsnzznine1", 0xa, "sevenfourlfzztcbplszbninesix1", 0xa, "htdtwoqxmhnbfxr23fiveone", 0xa, "qvvqnineqf1five", 0xa, "rchcjhvqxthv89pkqrffrvdthreesevennine", 0xa, "kzhtxmrzz3", 0xa, "sevengnmtfxfthreeqd3fzkbvpgghpkvcgzhthreeeight", 0xa, "fsmnfc3one3five9mkqgnkkbpt", 0xa, "js9hbszkvngrnine9trbdkr", 0xa, "grdflnvhrnjcxgtshh95f35seven", 0xa, "xb9fxdbcbdninefive", 0xa, "9sevenmfvdbljjnkkh6shmnhzhvhczhtqhnztltc", 0xa, "tgkxpgkhdrhnpltgptdfj8", 0xa, "4onesixfive", 0xa, "seven1rzpxlkmsbhfivexngj", 0xa, "plmhsjrgm414", 0xa, "8twobllkqgllczsix6onexsrvq", 0xa, "4nine6", 0xa, "vgfjtxhmqjtwopfrgbmr3", 0xa, "jhoneight9tsgeight8fivejccrsblkfsndpcmbjm", 0xa, "dcdkbmkttwothree3six5six8seven", 0xa, "seven9fivepxlhhhxpmmmtrvvxgrzsxx62", 0xa, "three59cksmfknhhdthreevpntxrnm3oneightpg", 0xa, "ninevcctklkbfdtlqv3five384", 0xa, "f4999tcvvgpdn", 0xa, "78three23sixonecqbrrkthree", 0xa, "lcsrnr5rbbmone9", 0xa, "eighthjjsxhvf7qdxnqsjpdlmzkv", 0xa, "86four", 0xa, "1four7one23threejvxh4", 0xa, "seventwoone9two", 0xa, "ninejjdhg3fzkqp9", 0xa, "nine14qjctcs1424vkc", 0xa, "two45", 0xa, "gpzgdzcqone55nine", 0xa, "766fourrvhfrdcqvqn1", 0xa, "cqfjjgbzhljcnjfnd1vhndrczpnhthreeeight", 0xa, "eightbzkgpvss7vpz16", 0xa, "oneqcxqckg2dgnxtwo7lqjslxmeightwovs", 0xa, "tzvmvcjxk5nineltsb4three9nine", 0xa, "mkeightwooneseven2", 0xa, "nrtkxhsevenzdfive3", 0xa, "6kxrt", 0xa, "9gp838", 0xa, "3sgtlcgvsix", 0xa, "dsqtwone42", 0xa, "9sixonekjtpvfoursevenrhfqgvc", 0xa, "3gh", 0xa, "eightzdzhmjj9onermrzjdlq3sbgtqmkcchx", 0xa, "22fourthree7", 0xa, "fxpeightccgmznphxghv2", 0xa, "five8eight", 0xa, "seven7ftgqfour", 0xa, "7fvjtfxkmskseven3xdhrmdmjntsneight", 0xa, "vgqspdltzsevenbknftljmsk71fivechpjzsvlnm5three", 0xa, "2fournine6", 0xa, "fchqnvjk51eightlfpmqtjtkv4bfpfour2", 0xa, "1sixltcvfh7nngbcfbtvsftwonlncst4", 0xa, "sevencp3sevenseven", 0xa, "lsqbbjsrthree5", 0xa, "tfbbmtvmcnjbdm1dtwo2ghgthc", 0xa, "9lmdspfheightxrgnsffcdkztbvfsvfxkqtnddp", 0xa, "2gllnfivexgnsst", 0xa, "sixm4", 0xa, "fourthree7twobcm5vxdtlcmcg", 0xa, "onenine873gszpxcsonep", 0xa, "2threenvxrbsxnjkonernsqrnqhzmsix5p2", 0xa, "sllbrnpsjztwo779", 0xa, "6dfive4zqmhpzcdqj8eight", 0xa, "5nineqdmbg", 0xa, "hbrffrnkvthreekjstcv7hvmngdfcn", 0xa, "21249", 0xa, "ninekdgfqppzt972five", 0xa, "7ljrvzfrklgmtqrstxkrkbjbpzeightxfnvr9", 0xa, "sevenfour9onesevensixlczmmlg", 0xa, "kcteightwo6752", 0xa, "fivethree9eight", 0xa, "zzgmn5nnfndqeightbzbcsxqpzj5one", 0xa, "6fourvqfhs", 0xa, "fivexfqvmrpgpgxz3", 0xa, "txqbhgcxjfive1seven44", 0xa, "82jonehgntqmxjbs5two2", 0xa, "4eightxmz53", 0xa, "lnzvmqrsgsfiveeight9", 0xa, "threefour7", 0xa, "seven4ljsevenfive", 0xa, "1jfcvdvgmb7scmcfsbbnine3", 0xa, "kpxpxsvvg4fcjxjcmltnineone4eightsix", 0xa, "zjdcddgtwogfbbmdvcczbcfjpcdtslckbtzqfive6nine", 0xa, "4tqghjdjnfour7six3", 0xa, "lgdtjjktwothree89scfivethree", 0xa, "3xvvmzshronefour6sevenktdjmrmfqtnvhvl", 0xa, "9fivexcpvthree8njncvnnz4", 0xa, "gcgx5sixdgqznrrstwo", 0xa, "1fivereightonefour", 0xa, "tfclzvrhb1five", 0xa, "xcq5", 0xa, "five9four8fourtrdbmcjjjvnine", 0xa, "63rlxseven7bltsm", 0xa, "1bnzzkgm7seven5onezqjvzrnbnxkgffvt", 0xa, "sixone9", 0xa, "7jzmnhjvzxfive8", 0xa, "16mbrtmstrhhsevenxkhgkmhreight", 0xa, "ninetwosevenp2ndddnhlczfnzx5pt", 0xa, "bv83blnnpfrbsone2ninethreethree", 0xa, "zjjvslrqpvrhxsix5z1nine8six", 0xa, "cqqfxzzxrnmvdvssevenrdm1dckrhjbdxpgqshlnxvj", 0xa, "78sevenkrsvceight2eight", 0xa, "twogrflcthree5gvmqfkpjfjcnqdhfourfour", 0xa, "dcttz7sevengtgstlznlgcmbzs", 0xa, "four64fournpxmfkdmqn1", 0xa, "gmgndczvqeight6sixhhfgdrzbl1three99", 0xa, "twoseventhreefivecfsdlmnzvlqbrszjdz2", 0xa, "onebh2", 0xa, "5tcrkzggfdfzq77", 0xa, "gjhfrt871hmgsix", 0xa, "qn589stxkhnlnhvzptzs6qlfvhz", 0xa, "qhtnjvdmtflxffour6sevenktgtr8", 0xa, "7sevenhjjdvmsixpqzxkkzcqzd", 0xa, "849six1kt", 0xa, "trhhcsndhtwoeightfournineszdrmrqhsq4", 0xa, "dfzrnine9", 0xa, "roneightgqnxnd18frkjgvhpngpcs9", 0xa, "3nine8lvkpzzqjkhxjjthree", 0xa, "2cmdmvnzb", 0xa, "dkxscqdrctgxzlflrlvtnkqlmrlgsrqseven8qlqrdz", 0xa, "4fivethree", 0xa, "2qtbhgfjcpchsjslm", 0xa, "gtvvdchll61gczsrlxhgf356", 0xa, "6onegckf4seven4sbntwotwo", 0xa, "ccstwone1872hdv2", 0xa, "515mhxpngvzqt", 0xa, "fourjhhfsbonexdzhgrseven3", 0xa, "twoxklx6seven4ninethreertczhbsfour", 0xa, "rhtl4pg1four", 0xa, "6dlprbkclc4nxvfqkpt", 0xa, "5onelkmrhczkm", 0xa, "zqhxmhgkone5xpkvsntwo3", 0xa, "2two461", 0xa, "twolr6two4bzssevenfive", 0xa, "2oneone7ninetsgxlx332", 0xa, "eight3hvlzpxtcs", 0xa, "25eight3tbpccjbx3sdcmt", 0xa, "krdzhfh2sixeightgrszdxt", 0xa, "tjxlhrgmqcdspzdb6ssgqnxcxlvbfivetwo", 0xa, "snninedqlbnhqzjthreebhfnfrf3pfcqzfnffhsix8", 0xa, "8nine3", 0xa, "9five1xlbvsix5sdcrlhgtffxb", 0xa, "seventrldtzv5ninetwofive7four7", 0xa, "blbvthree1grdhltsevenfive", 0xa, "fkrhh4gd1", 0xa, "1jncdsphsnjzkxphbdftksc5dtgsixone", 0xa, "fglnthreehgkx31", 0xa, "threexnfour8threefive", 0xa, "zzjnmhvbltp1", 0xa, "6vcjxszkfmkprpl32cfjsrhzmdfourjdflnfql", 0xa, "49tlsqspjjcmtjvpd4", 0xa, "7sevenjfqpktqpdhonethreefpjqhbjcpfourdzzcbxp", 0xa, "xn7sixeight9dphpvscjlxdtwovjbnx", 0xa, "tzgrvrkgbs7cfzf2eight76eight", 0xa, "4xlnzqrxqk8two97vxjninelmhzhv", 0xa, "ninedqlbgpbmf7dhmshsbq2eighteightpgzq", 0xa, "fourthree825", 0xa, "jcqftlf2threecbnine24lds", 0xa, "fourtxnine8zhlzcqjmvk", 0xa, "5two3", 0xa, "zfkdgfourtwoc4", 0xa, "7fivefch", 0xa, "fourqrvjmbninelcvjlgqxmvhf2hldvjzhl7seven", 0xa, "vkfeightwo8four5seven", 0xa, "79fxdpd", 0xa, "tdjspcsixdqrgkxvk1vjmggfpbrvfour", 0xa, "43tnmdpslnxfourtwovnzdzhvteightseven", 0xa, "threenine1zklgrlllhonekn6", 0xa, "one2zhnthreez", 0xa, "bone11npzv", 0xa, "five44614jnzxvdjhm", 0xa, "277seven1", 0xa, "6djmb65nglbkzrlpfgsqchbp18", 0xa, "ninesix2four", 0xa, "four8nshkzhzvxlxxnngxvfive", 0xa, "2threejrxhhqkctsthreemdqzpxxrrglnine8nine", 0xa, "1xdm", 0xa, "kgnprzeight7nine", 0xa, "mssbnjdcjvvtpnsrnslmeightbzl3nr", 0xa, "9dppkrcf6oneoneeighteightklmtfvl", 0xa, "8ninebrzqx4kbhkcp6", 0xa, "seven1hklsjbdqzp1zc", 0xa, "twofcbxntcskg1onezzqfrff", 0xa, "94xssjlkccfbljz", 0xa, "spfive47ssjssevenrz2two", 0xa, "98threelc676", 0xa, "mxrgthreezzkhcmoneseven7three", 0xa, "crdvdtq5sixone97", 0xa, "8eightbvbg", 0xa, "gvjscdfkdmseventhree2nbvbzmdmmtrfive", 0xa, "1threesevenhcxggpds4two12six", 0xa, "5onekxzkfour8", 0xa, "2ddeight4", 0xa, "645", 0xa, "ninejjrlhdhjtzmrlvljfr98", 0xa, "seven11ninebvbtnbzdmblbjvzsh", 0xa, "9nine59xmdktjsnseventhree", 0xa, "qdxgtk6126vxcgtxkkbqjrpfntvsprq", 0xa, "75cqkfddg5ninejkbvpsbcltssh1", 0xa, "3onerfpqbsvone39one3nrxmbk", 0xa, "1612three1", 0xa, "8hqrsksevenldcqrcfxhr", 0xa, "ninerfkxndfhhkfivefjntjzxhgpbbffvfour2sg1", 0xa, "seven37kbxszsgpt", 0xa, "89435jpgsfiverhsztt", 0xa, "threeseven1sixsix21five6", 0xa, "pzht15gxvjlvsfour6eight8two", 0xa, "lkvcseven771gcvrsvsshtppdgxnvclqhnjlvvthree", 0xa, "sevenmpghzvvrd6", 0xa, "8vprrlcq9xzhmhnj4", 0xa, "dxhsxknone1two4", 0xa, "eight64d", 0xa, "8jqdlcsixzzhvnnfiveqbtlhrr", 0xa, "9eight5nine5fiverk", 0xa, "xhhxgf5bfsbthreesthreeltlvhvrjnslxhsrp", 0xa, "twoqccssix55twofour3vtsjxk", 0xa, "goneightpqgblvhpmp4sevenonethree9sixsixfour", 0xa, "onethree536xhznine7df", 0xa, "998", 0xa, "hsix23three", 0xa, "chgtqonenvxtlrhxvxmbbl5", 0xa, "2zkzg", 0xa, "1hgrpzshm5onebcgpfv9onecgtr", 0xa, "3sixonevldsdlxqtjsnlt5onehxdpfive", 0xa, "eighteight59phbd9ldnvdlsxninenine", 0xa, "zseven9", 0xa, "xptwonekdrnv2", 0xa, "5tsmnbhxhzrtfbknbqsevensnxbqrhs5", 0xa, "694onebvmscclkbsfour1kxgfxdbfour", 0xa, "g2ninetwoned", 0xa, "gmlsjjttcngblmjhtgkz3fourdrzrrmsszfivefive", 0xa, "gtmzmkrktmrkfive8tq5", 0xa, "eight1four", 0xa, "8eightthreevqgtlfxrm4three6mnrfzvpkbl", 0xa, "szrbvtwo3lqbxthreefivemshzfgjzlllrmr6", 0xa, "kzczdbjcbnine8nnineninevfbt3vsvcplsnj", 0xa, "ninesevensmgfsix5fivedfpxvmtmcsgzpbppfjt", 0xa, "sevenctdzznone7three5kngbthreenine", 0xa, "44sixoneonesix", 0xa, "nine9fiverrbbrqtfive53", 0xa, "onesix2oneseventhree3rmpjl", 0xa, "23htxtgxqkseven", 0xa, "fourlkbsix3twonndccsseightbs", 0xa, "eight8two5four3", 0xa, "five8dvxpqfsixghrkg3fourninetfsdbxzp", 0xa, "bhtqtclbsix6jlvxtgmq", 0xa, "498three1", 0xa, "2t", 0xa, "7five3bcjxsglnxqjxjqfb", 0xa, "6seveneightxvmqgbklgnbfgzlncvg", 0xa, "89nine74gbgbcone", 0xa, "8dtln6", 0xa, "svtl5eight8", 0xa, "jsxzlsix8bzrmcl659lrmgtnpv", 0xa, "64rklskvlndm6ninextbrs4", 0xa, "voneight79two", 0xa, "sbzdmjbtwo7dnglczphb77fvhtwo", 0xa, "two3eightwoj", 0xa, "rtoneighttsgeight89nine4", 0xa, "3six8vbdbthxxffgm", 0xa, "rxgoneight4mtqdpzbfndtsvsrzt", 0xa, "7one4lbqcfnffive8", 0xa, "fivecd8two2eight", 0xa, "twofivefive6twotwoklvbdstxfcvsm9", 0xa, "threemdrdnhl7sixseven46mctldxnn", 0xa, "5njljbxdrcbrrm3ninec", 0xa, "5jg6eight4", 0xa, "ninethreetwo6dnldknsnn", 0xa, "xrpczvvfnpjfbpvxzjzpmrkpb8fivesixtwonetj", 0xa, "4five4vmone3td6", 0xa, "77jbgjkgkfd1691lfp", 0xa, "fhxvlvct6", 0xa, "scjeightwo6onedjz71jslzdfxp", 0xa, "7eightpblnnbvqtvtwoseven", 0xa, "btdgplkdvl5rlzjkthree2threefive", 0xa, "298", 0xa, "7hhfxtfcvsqjvsxpbdjqzxngg832tdznpfhz8", 0xa, "drhfzlnlcrsix2dbjqhrxzqrsixsevengrnine", 0xa, "sixninesixoneeighttwo96", 0xa, "onekqzjft4zdspcvmbjtzbsixv", 0xa, "sixgkx74", 0xa, "75eightqvblvm2gtjmcljphjvtwonesq", 0xa, "bcmqtltwoxsbkvhdv96df81", 0xa, "eight3bk45sixninezdnntshfv", 0xa, "9threetwosix", 0xa, "2vrfzsvcprnjzngl2nine", 0xa, "fivekdhcgrpznvsix2nmhthl27", 0xa, "195", 0xa, "four8tspldsixzzqxrqqmsr", 0xa, "8bnvksmmlhnfive372jmxhj", 0xa, "nineseven6threeeightnine7vtzmpf", 0xa, "2twofivehbponevptflmzgxljzfour", 0xa, "85eight81two", 0xa, "2ctnhxfivethree148vjtzfdfkkfvvtgb", 0xa, "62sixpsfjzcxzlzsjbtxnjpbctgcjm9", 0xa, "gmclvqfq1", 0xa, "32csv9dgfxsjm", 0xa, "4fjcdrzmznhfive33345", 0xa, "62eightrdplbxdhfq1eight", 0xa, "4four97skpvpphtbqmmsckxpdqnfour", 0xa, "913sevennmmbbnntrs", 0xa, "862twonec", 0xa, "three2four7foureighttwo6", 0xa, "ninejnt721nine8", 0xa, "eight1gpnrlklmxt", 0xa, "nine2mrzvhlzxgninesixkp", 0xa, "cklsqdf9nine3", 0xa, "seventhreefivehdnkjqtd4tcjxpbcvpjsvbhdvx3frkc", 0xa, "one85sbrtsftwo6", 0xa, "sixnine8nineone46six", 0xa, "dmtlrzkfdsdklbvzckjmnthkkmqh9", 0xa, "ninetwojone8", 0xa, "bfneighttwo5", 0xa, "slqmsbnl4mmeight7", 0xa, "55dnsb2485", 0xa, "fivesixmzvmsmkkhd86twotwofour", 0xa, "gppnzsevenninemzbzzqqhzvgclndss16", 0xa, "8two7r", 0xa, "8xsevenbfvhdqxtwoeight86", 0xa, "fnnineeight1eightninenine8twonejgf", 0xa, "five7three51", 0xa, "eightthreevsnn4seven", 0xa, "nhhjkxhtxp4csfeight", 0xa, "2nine9sixfour9", 0xa, "fveighttvjxbhzfour7ninetwo", 0xa, "5eight6", 0xa, "txnxcrx3", 0xa, "chbmjvmlfqfgsg2hdg", 0xa, "56five29hrrjgxnrbnzjjktdfqssjqksxn", 0xa, "eighttwohszdlc7veight", 0xa, "5ltglgmlfkkbzkvh", 0xa, "eight336gbxmzjsbpgztprdv2eighttwo", 0xa, "five44", 0xa, "kdfbgxpcqtdlksc4threefournineeightnshlmfvs", 0xa, "1c5six", 0xa, "nss7bccb", 0xa, "34eight9six92", 0xa, "onetwofivedblgtrxzpvmrhhsj2jhrcbbsseven3", 0xa, "vxkczjfhnine5drz", 0xa, "bfourqkmt1", 0xa, "two2onedgxgmffcg1", 0xa, "3threenine6vlstktnqdzfive", 0xa, "three8gsqdqpv", 0xa, "7ndgkns", 0xa, "4onerglbzsjrkqskljcgthree", 0xa, "zxkgzkvn7fssgdsblvksixn", 0xa, "788sjxcxmtxfivezzpgsbzbtl8fourtwo", 0xa, "9mhrlcsqqgzjrfnd", 0xa, "7kbmhmlghssix231", 0xa, "7tcfv6jpkxnzmrtx2", 0xa, "bcxvhcjbhsxbgbrj28fivenhk", 0xa, "jrm3447", 0xa, "ljsix29mhrmrjpcfqone", 0xa, "xqdxkzls46", 0xa, "bmhnfnd9qmbndfhqnv9bhdpqxthreefbptttwosix", 0xa, "six9three5blqp37seven", 0xa, "44ffvsnxttwo8seven", 0xa, "cmjccpp34threesix6jhthree", 0xa, "eight86", 0xa, "3vqqjlgdj9zncvjhbpr2d", 0xa, "26sfzqpfgfivetwo56", 0xa, "xljmtkjkzthree8", 0xa, "ninesevenfourtsctjhvfive4dt", 0xa, "jzsxmmxmpllqpmszczxzghpxp4", 0xa, "hcrtjnvghvnthree5one", 0xa, "5twoeightsktxhmkpcts", 0xa, "ltrkvbzlnccrmrsfmjrbfjrh75", 0xa, "cbxfpfsix8lkbqh", 0xa, "9mseven7fivefivexdjxct5", 0xa, "9sevenklrvhclkrfourtwo96four", 0xa, "2pkbthree", 0xa, "kqpbhjxzfn147", 0xa, "nineqnjxrmq2gnineh", 0xa, "5sixcrtgqqlqflm", 0xa, "9fourzjzmhmnksxc", 0xa, "four86rdndxscqnjcxghnvgmzp3", 0xa, "mqmfive98eightmbxrgddqbbqone", 0xa, "gtb66rbclkxdl4spzpgqmkdh3", 0xa, "965two", 0xa, "96pskqjvckxffkone8four4", 0xa, "three9xlf1", 0xa, "spczeight9dvg", 0xa, "v6two", 0xa, "pgksdtnkbbninef5zttwo2seven", 0xa, "4gnvxkc", 0xa, "9four43sixtwofzf", 0xa, "3xsbfcsixsix4eighteight2one", 0xa, "3oneeighttwo", 0xa, "ptwonetwoskjsspjhmxrmvlzcqz572fourmpxx", 0xa, "threeonetwotwo2", 0xa, "slcseven1xtxbpfb", 0xa, "peightwothree7pdmktbcfouroneninekrf6two", 0xa, "668", 0xa, "lxshscpkv8fmhcpslhpp", 0xa, "tzrdone7onethreectwo", 0xa, "8pkkpdmzhfourcmjljfour73hhqqmfc", 0xa, "one71ninesix8oneighthlx", 0xa, "72pjpmfcgjhvsixksgrjthreegcspcdxchxkxflmh", 0xa, "4bzr98threeksb", 0xa, "9one6xdfcsvbbqfour", 0xa, "hr5eight33", 0xa, "zgsvc9", 0xa, "71hfourtch395pvnzsmhdf", 0xa, "zsvppvgzllgf22", 0xa, "threebkkrcqzvnt4rjblsnsixninetrjgjjvlv2", 0xa, "289", 0xa, "krqdkcfbpp48fivefour", 0xa, "five7tgpt5flkone", 0xa, "eightfive31twoghnqffp6", 0xa, "eightseven6oneckpsixtwo1", 0xa, "4l4", 0xa, "4sevenxzdnprlcjrfive", 0xa, "68vntztlbjqtqkstsp7lkhcgpbtdmzrndsix", 0xa, "onesix2", 0xa, "sixhc4hhglhp7281h", 0xa, "3zvhhv", 0xa, "lmfsqtnzfk52qrdh", 0xa, "fourbvnsjfjfive87seven1", 0xa, "twoonesixsix1twodxjdkdeight", 0xa, "nnine3", 0xa, "ccclkfdb2lftfhnjcqd", 0xa, "1q", 0xa, "gtcdzjhfv8p9", 0xa, "fivefqxrfourtwo62eighthdcsqrmxjv", 0xa, "one556mgtsdvkqfiveseventwo3", 0xa, "mvkrxnj34psqtwojhrdjgthree5", 0xa, "sevencndnndjfzp2eightqcbhvb", 0xa, "eighttbvvck2fiveone6vkljmslcrsghk", 0xa, "tqdhnzfrr6fourzf", 0xa, "ninecqxgkbsv7", 0xa, "8nsl4sixnxrcdhtkeight3", 0xa, "sevenxsczhz6dv4sc9brxnsms", 0xa, "5glknvqzlqvmzvnzrb1", 0xa, "5oneqcshgqbfp1", 0xa, "5two1sixsevenjpgnbvjpcgd1eightwoh", 0xa, "2qglrzsxz", 0xa, "fpdthreek2", 0xa, "gplr51sevenfg34jhhp", 0xa, "six78tbzz", 0xa, "hntwonethreergcp7", 0xa, "59fivefive5", 0xa, "threezfjxxtqrvhjcdkjsevenhgp44fivetphhfbdtxs", 0xa, "njkd2dcddfzpvpfqp", 0xa, "3sixgnnl", 0xa, "6ninefdqzfpxspsnzs13gz4", 0xa, "3four66one", 0xa, "fivesevenczmt22nfvnxhbvgjtvjmdzhfqhxtthree", 0xa, "sttx4gktnine5vlqjzddkr", 0xa, "4fivejpsscfqdtgjmtvrljdseveneight", 0xa, "xtfqvnpsfnfppx12rvcldvkhbb", 0xa, "62hj4oneqlp4seven", 0xa, "6hdnlgrfdccsqsxjqrv", 0xa, "331", 0xa, "nine6eight", 0xa, "two6mbfdmgpfourng", 0xa, "fmnv3three3", 0xa, "nine5hvzkrjtwo", 0xa, "6eight73", 0xa, "fourfive79six7two1", 0xa, "thzhjrfsfoureight53", 0xa, "1lzfxgvtxgdxtsixffptldz1srgsnvtpnsevensix", 0xa, "seven8onertbqhthreefourctdbsrcvcsjlvcxneight", 0xa, "5eightfive3", 0xa, "6phjbkvrjd", 0xa, "gssfoursevengvtfznklj97", 0xa, "fivemgrddqslp3", 0xa, "ninetwo6sixpv", 0xa, "lhdjm82tlnqrxqtvd", 0xa, "six7hpcjqnrszkfiveftvjnhjsevendqmmr", 0xa, "m2cjfjcb", 0xa, "thfive27fjnshtwo", 0xa, "vmzxlq7", 0xa, "xlg3nine", 0xa, "schnfive33sevenninedhpjfrsixeightwoxr", 0xa, "bmnine3mgrttsevennvhtdszmtxoneone", 0xa, "zgkqdrvfjtg1sixbsqgdjfivelnrmpqqstv6seven", 0xa, "ljln11fourgjgvfmhmninekdlpjmrn", 0xa, "jffhrkpm22sbnsrpxg9three", 0xa, "fourtwo1sixjvv55ttflnvshb", 0xa, "xgndhkmdnxgrhqh4lm", 0xa, "87five6nineddnrzd", 0xa, "9pmmddvffivesix3one37", 0xa, "2flddmzcjbfrbdxzhvhsrx16twonej", 0xa, "knzfrseven71fjzhmdznfthree", 0xa, "9five84dfj", 0xa, "sevenc1qhxqhgl", 0xa, "flkdskjjzmqtcmljkone49ljffjtxhs9eightwopq", 0xa, "qhhktqkdfjzth5eight6", 0xa, "sevensixmvvrzhsixsixsix9", 0xa, "2241", 0xa, "1xzjfpjkkcltvznzzfrh", 0xa, "jrvcznlvfgntthree5fivejqrheightwoxkh", 0xa, "lqxtk1oneone3rkfive", 0xa, "hqjbpqjeight3588", 0xa, "one96sixkbgcx6zhmnine", 0xa, "eight77six", 0xa, "four46nine31five3five", 0xa, "lhd8two7dhthqhbzvlknvtrlfthreeninethreetwonez", 0xa, "5cdgllrdsspnninerxdphcsstt", 0xa, "s9twosixonezcrfmcd", 0xa, "dtqfrnrtdn2threespcfh", 0xa, "113six", 0xa, "onefkznlfjpkfivethree47three", 0xa, "f4hlxdlndqp4blmbzxfvone", 0xa, "czsdseven22ht9threepmfhdpq", 0xa, "7mdvchlcpn", 0xa, "5ssxkrgvhthmleight", 0xa, "seven13four7fiveq", 0xa, "threetcstlhfcqdfhjgccckcvk1hjlpmmkjmr8six", 0xa, "sljoneightg8fourfrsfbgfktr", 0xa, "jfeightwolzcmztqeighttftr3oneonefour", 0xa, "four7tdkq8threeeightfcgpddp", 0xa, "drj3vlj5tcjsfbzffcmmqmgtt5", 0xa, "82", 0xa, "jsvzmkqrlkkvfmdxjrshhnsixseven53three", 0xa, "seven1twoninebdpb4", 0xa, "bjhtgqbfnccspgzbhlqgdzfznxhsixgdfkg91two", 0xa, "fqzrrbchbmhrneightclvd1", 0xa, "sixeightseven1rlnlqlm", 0xa, "pxxtd793frjfckbhstcdhsrx58mksktwoneqx", 0xa, "zccxxqcfglnnrxdonefivevxtxgzgkh51", 0xa, "fivenzrmrjfpjhxhkxthtkdrqfthree2twoeight", 0xa, "kzjn9fourqmglnxmqfivenfg51", 0xa, "cxeightwo8lzqcdlmbgt5", 0xa, "fivekmfkjnqseven9jlts4", 0xa, "724dtlznnqtthreeeight54one", 0xa, "7ninesevennine", 0xa, "dj5zhmxtgsdpzlkzcbvnldeight3kk5mmvs", 0xa, "19hczk", 0xa, "3sevenhlkttqsqllsbplone", 0xa, "fourtzlbxhvt7ht54dvtkdprljj9", 0xa, "fourmvpzqjnb2hmhc3zjvlgrxsm", 0xa, "onekqjtd8five", 0xa, "82rbnsg48twoseven", 0xa, "four352", 0xa, "2rlxcfoursixczbvb9", 0xa, "5fourjxggrtg9bmrlnmmhsgtwo96", 0xa, "8nd2foureight7qg5nine", 0xa, "8twozx", 0xa, "rpfmg3twoeight87", 0xa, "13five5", 0xa, "one39six55ninenhhdd", 0xa, "9eightnineone", 0xa, "321fivefour", 0xa, "531sevenhxznfmdxnxfptkbcfpn84xtjrbrmbxk", 0xa, "5tqkzdf6", 0xa, "sevenlnmnzh35fivetwotrbnknfive", 0xa, "qjqbcbhlqfive8mfmxdssvtdhq", 0xa, "threesixlxmhgzxxjxrgmxzqprl7", 0xa, "24nnjmxxkbxjmmdssdpb8twotwoone", 0xa, "9four7", 0xa, "9sixtgj29eight8", 0xa, "fivebvzrbftvvdzd5nctrmjmbx5eight3", 0xa, "4threedfzlzxfprzqpkzmlnsix9four", 0xa, "qbqjfbqthxvhnine99five7kgqm", 0xa, "pdvcpcdvjninethreethreeseven5", 0xa, "ninelrsshpxvb32trfrhnnbkseven5", 0xa, "1zktcvtrknt", 0xa, "tbxt59dfqzxcdj", 0xa, "zclzlgcmkneightzskgbg62five", 0xa, "vlhtm4gsjtcvkkprsix1sixmdkxlgp76", 0xa, "vxgmnjsixfivesix69threejlrrcc", 0xa, "onefive5sevenfhvsbfpcxbqn1one1", 0xa, "rlxrbhtwobmhfcgnmtg6zlgz95sncg", 0xa, "6tgsl", 0xa, "mjsjpone9", 0xa, "rsqfmseven5qqhrxhfxf6twohnxjgh66", 0xa, "xbfqgxkxmninegmhcrcmxgllktllbqpsvrfthree9", 0xa, "2one7kthlnfive3kq", 0xa, "sixfour8lztglpvfv5", 0xa, "bjcrvvglvjn1", 0xa, "3mlfdone42", 0xa, "4one5twoxqfcflcbjqsixeightdlknnzdbzlrqfkhvm", 0xa, "cfpnhsgs956", 0xa, "xsdm7lhcjzk3hstcf", 0xa, "9fourcsjph86shfqjrxlfourninev", 0xa, "bgcxqff8", 0xa, "4eightv51", 0xa, "six6two4lvtjt61", 0xa, "44kmn", 0xa, "rbgfivefive3eightthree", 0xa, "three4nhvblteightfour", 0xa, "2six64rjmcvvxshxjlndj", 0xa, "3nine4fourjclspd152rpv", 0xa
input_len equ  $ - input_str


file_end:
