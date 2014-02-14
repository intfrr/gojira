###################### Gojira ######################
# Coded by The X-C3LL (J.M. Fernández)             #
# Email: overloadblog////hotmail////es             #
# Blog: 0verl0ad.blogspot.com                      #
# Twitter: https://twitter.com/TheXC3LL            #
######################  v0.1  ######################

use LWP::UserAgent;
use Getopt::Long;


GetOptions(
        "dic"=> \$flag_dic,
	"help"=> \$flag_help,
	"enu=s"=> \$flag_enu,
	"users"=> \$flag_user,
	"url=s"=> \$flag_url,
	"robots=s"=> \$flag_robots,
	"version"=> \$flag_ver
         );


print q('            ,.-·^*ª'` ·,               , ·. ,.-·~·.,   ‘                 ,·´¨'`·,'         ,.-·.          ,. -  .,                              ,.,   '      
'         .·´ ,·'´:¯'`·,  '\‘           /  ·'´,.-·-.,   `,'‚                :,   .:´\        /    ;'\'      ,' ,. -  .,  `' ·,                     ;´   '· .,     
'       ,´  ,'\:::::::::\,.·\'         /  .'´\:::::::'\   '\ °              ;   :\:::\      ;    ;:::\     '; '·~;:::::'`,   ';\                .´  .-,    ';\   
'      /   /:::\;·'´¯'`·;\:::\°    ,·'  ,'::::\:;:-·-:';  ';\‚             ;  ,':::\·´'     ';    ;::::;'     ;   ,':\::;:´  .·´::\'             /   /:\:';   ;:'\' 
'     ;   ;:::;'          '\;:·´   ;.   ';:::;´       ,'  ,':'\‚ ,.,      .'  ,'::::;''        ;   ;::::;      ;  ·'-·'´,.-·'´:::::::';          ,'  ,'::::'\';  ;::'; 
'    ';   ;::/      ,·´¯';  °      ';   ;::;       ,'´ .'´\::';‚;   '\   ;  ,'::::;         ';  ;'::::;     ;´    ':,´:::::::::::·´'       ,.-·'  '·~^*'´¨,  ';::; 
'    ';   '·;'   ,.·´,    ;'\        ';   ':;:   ,.·´,.·´::::\;'° \  ';',·'  ,'::::;          ;  ';:::';       ';  ,    `·:;:-·'´            ':,  ,·:²*´¨¯'`;  ;::'; 
'    \'·.    `'´,.·:´';   ;::\'       \·,   `*´,.·'´::::::;·´     '\    ,.'\::::;''          ';  ;::::;'      ; ,':\'`:·.,  ` ·.,           ,'  / \::::::::';  ;::'; 
'     '\::\¯::::::::';   ;::'; ‘      \\:¯::\:::::::;:·´          \¯\::::\:;' ‘           \*´\:::;‘      \·-;::\:::::'`:·-.,';        ,' ,'::::\·²*'´¨¯':,'\:;  
'       `·:\:::;:·´';.·´\::;'          `\:::::\;::·'´  °            '\::\;:·´'               '\::\:;'        \::\:;'` ·:;:::::\::\'      \`¨\:::/          \::\'  
'           ¯      \::::\;'‚              ¯                         ¯       °              `*´‘          '·-·'       `' · -':::''      '\::\;'            '\;'  '
'                    '\:·´'                 ‘                                                                                            `¨'                  
								http://0verl0ad.blogspot.com



);
if ($flag_dic) { &dic; } 
if ($flag_ver) { &version; }
if ($flag_robots) { &robots; }
if ($flag_user) { &user; }
if ($flag_enu) { &enu($flag_url); }
if ($flag_help) { &help; }


#Subrutina para generar un diccionario basado en los 3.000 plugins más populares
sub dic {
	 $url_dic = "http://wordpress.org/plugins/browse/popular/page/";
	 $file = "dic_populares.txt";
	 $pages = "200"; # 3000 plugins. Feel free to edit it
	 $i = "1";
	open(FILE, ">", $file);

	print "[!] Creando diccionario... \n";
	while ($i <= $pages) {
		 $ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
		 $response = $ua->get($url_dic.$i);
		 $html = $response->decoded_content;
		 @contenido = split("\n", $html);
		 foreach my $linea (@contenido){
			if($linea =~ m/\<h3\>\<a href=\"http\:\/\/wordpress.org\/plugins(.*?)\<\/a\>\<\/h3\>/g) {
				$linea = $1;
				$linea =~ s/\"\>/=====/;
				print FILE $linea."\n";
				print "\n".$linea; 
			}
		}
		$i++;
	} 
	close(FILE);
	print "\n\n[!] Creación del diccionario finalizada";
}

#Subrutina con información de cómo usarla
sub help {
print q( 
To use it> perl gojira.pl [options]
[OPTIONS]
	--help		Show this information
	--dic		Download a dictionary with most popular plugins
	--url		Target URL
	--enu=[DIC]	Enumerate plugins installed in target using [DIC]
	--users		Start to enumerate users registered
	--robots=[HOST] Check robots.txt in the designed [HOST]
	--version	Extract WordPress version
);
}


#Subrutina que realiza el escaneo vía peticiones HTTP
sub enu {
	$target = $flag_url."/wp-content/plugins";
	$dic = $flag_enu;
	print "[!] Iniciando escaneo de plugins...\n\n";
	open(PLUGINS, "<", $flag_enu);
	@listaP = <PLUGINS>;
	$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
	foreach $linea (@listaP) {
		chomp($linea);
		@separado = split("=====", $linea);
		$response = $ua->get($target.$separado[0]);
		if ($response->status_line !~ /404/ and $response->status_line !~ /500/ and $response->status_line != /302/){
			print "[+] Posible plugin detectado ~> ".$separado[1]."\n";
		}
		
	}
	close(PLUGINS);
	print "\n[!] Finalizado el escaneo de plugins";
	
}

#Subrutina para extraer los usuarios usando ?author=ID
sub user {
	$target = $flag_url;
	$i = "1";
	print "[!] Para poder iniciar la busqueda de usuarios primero usted debe indicar el patron a eliminar\n";
	print "[!] Copie y pege debajo el texto que viene DESPUES del author incluyendo el espacio\n\n";
	$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
	$response = $ua->get($target."/?author=".$i);
	$html = $response->decoded_content;
	@contenido = split("\n", $html);
	foreach $linea (@contenido) {
		if ($linea =~ m/\<title\>(.*?)\<\/title\>/g) {
			print "/!\\-> ".$1."\n\nInserte aqui > ";
			$patron = <STDIN>;
			chomp($patron);
			$size = length($patron);
			$off = 0 - $size;
		}
	}
	print "\n[!] Iniciando escaneo de usuarios...\n\n";
	while ($i != -1) {
		$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
		$response = $ua->get($target."/?author=".$i);
		$html = $response->decoded_content;
		@contenido = split("\n", $html);
		foreach $linea (@contenido) {
			if ($linea =~ m/\<title\>(.*?)\<\/title\>/g) {
				$titulo = $1;
			}

		}
		$tl = length($titulo);
		$cl = $tl - $size;
		$ucheck = substr($titulo,0, $cl);
		if ($usuario and $ucheck eq $usuario) {
			$i = "-1";
		} else {
			$tl = length($titulo);
			$ul = $tl - $size;
			$usuario = substr($titulo,0, $ul);
			print "[+] Posible usuario encontrado ~> ".$usuario."\n";
			$i++;
		}
	}
	print "\n\n[!] Finalizado el escaneo de usuarios\n";
}

#Subrutina para comprobar robots.txt. Idea extraída del programa "Parsero"
sub robots {
	$target = $flag_robots."/robots.txt";
	@urls;
	print "[!] Localizando y comprobando las rutas que aparecen en robots.txt\n\n";
	$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');	
	$response = $ua->get($target);
	$txt = $response->decoded_content;
	@contenido = split("\n", $txt);
	foreach $linea (@contenido) {
		if ($linea =~ m/Disallow\:/g) {
			$linea =~ s/Disallow\: //;
			push(@urls, $linea);
		}
		if ($linea =~ m/Allow\:/g) {
			$linea =~ s/Allow\: //;
			push(@urls, $linea);
		}
	}
	foreach $url (@urls) {
		$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');	
		$response = $ua->get($flag_robots.$url);
		print "[+] Checking $url... Status Code: ". $response->status_line."\n";	
			
	}		
	
}


#Subrutina para sacar la versión del WordPress
sub version {
	$target = $flag_url;
	@links;
	print "[!] Empezando fingerprint...\n\n";
	$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');	
	$response = $ua->get($target);
	$html = $response->decoded_content;
	@contenido = split("\n", $html);
	foreach $linea (@contenido) {
		if ($linea =~ m/s\?ver=(.*?)\'/g) {
		push(@links, $1);
		}
		if ($linea =~ m/\"generator\" content=\"(.*?)\" /g) { 
			$meta = $1;
		}
	}
	if ($meta) {
		print "[+] Meta generator version! => $meta\n";
	}
	#Vamos a sacar la moda a pelo, como los campeones
	%veces;
	foreach $elemento (@links) {
		$veces{$elemento} += 1;
	}
	$max = 0;
	$pos = $max;
	foreach $n ( keys %veces ) {
		if ($max < $veces{$n}) {
			$max = $n;
		}
	}

	print "[+] Version deducida por los links! => WordPress $max\n";

	$ua = LWP::UserAgent->new;
	$response = $ua->get($target."/readme.html");
	$html = $response->decoded_content;
	@contenido = split("\n", $html);
	foreach $linea (@contenido) {
		if ($linea =~ m/Version/g) {
			$linea =~ s/	\<br \/> Version //;
			print "[+] Readme encontrado! => WordPress ".$linea."\n\n";
		}
	}
}


print "\n";
