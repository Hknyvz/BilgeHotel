create database BilgeHotel
go
use BilgeHotel
go
create table VardiyaTipleri
(
	Id tinyint primary key identity(1,1),
	Ad varchar(10) not null, 
	BaslamaSaati time(0) not null,
	BitisSaati time(0) not null
)
go
create table Maaslar
(
	Id smallint primary key identity(1,1),
	MaasTanimi nvarchar(30) not null,
	Maas decimal(7,2)not null check(Maas>0)
)
go
create table Gorevler
(
	Id tinyint primary key identity(1,1),
	Pozisyon nvarchar(30)not null
)
go
create table KanGruplari
(
	Id tinyint primary key identity(1,1),
	KanGrubu nvarchar(3)not null
)
go
create table Ulkeler
(
	Id tinyint primary key identity(1,1),
	Ad nvarchar(100)not null
)
go
create table Sehirler
(
	Id int primary key identity(1,1),
	UlkeId tinyint references Ulkeler(Id)not null, 
	Ad nvarchar(100)not null
)
go
create table Ilceler
(
	Id int primary key identity(1,1),
	SehirId int references Sehirler(Id)not null,
	Ad nvarchar(50) not null
)
go
create table Mahalleler
(
	Id int primary key identity(1,1),
	IlceId int references Ilceler(Id)not null,
	Ad nvarchar(50) not null
)
go
create table Sokaklar
(
	Id int primary key identity(1,1),
	MahalleId int references Mahalleler(Id)not null,
	Ad nvarchar(50) not null
)
go
create table Musteriler
(
	Id int primary key identity(1,1),
	Ad nvarchar(20) not null,
	Soyad nvarchar(30) not null,
	Cinsiyet char(1) not null,
	TcNo bigint not null check (len(TcNo)=11),
	Tel bigint not null check(len(Tel)=10),
	Email nvarchar(30),
	Sifre nvarchar(20) check(len(Sifre)>8)
)
go
create table OdaTipleri
(
	Id tinyint primary key identity(1,1),
	Ad nvarchar(50) not null,
	Aciklama nvarchar(300),
	OdaPuan tinyint check (OdaPuan<10)
)
create table Fotograflar
(
	Id smallint primary key identity(1,1),
	OdaTipiId tinyint references Odatipleri(Id) not null,
	FotografUrl nvarchar(200)
)
go
create table OdaImkanlari
(
	Id tinyint primary key identity(1,1),
	Ad nvarchar(50) not null,
)
go
create table OdaImkanlariOdaTipleri
(
	OdaImkanId tinyint references OdaImkanlari(Id),
	OdaTipiId tinyint references OdaTipleri(Id),
	Miktar tinyint not null check (Miktar>0)
	constraint PK_OdaImkanlariOdaTipleri primary key(OdaImkanId,OdaTipiId)
)
go
create table HizmetPaketleri
(
	Id smallint primary key identity(1,1),
	Ad nvarchar(50) not null,
	Fiyat decimal(6,2) not null check(Fiyat>0)
)
go
create table OdaTipleriHizmetPaketleri
(
	OdaTipiId tinyint references OdaTipleri(Id),
	HizmetPaketId smallint references HizmetPaketleri(Id),
	constraint PK_OdaTipleriOdaImkanlari primary key(OdaTipiId,HizmetPaketId)
)
go
create table IndirimTanimlari
(
	Id smallint primary key identity(1,1),
	IndirimAdi nvarchar(30) not null,
	IndirimOrani decimal(5,2) check(IndirimOrani>0),
	GunSayisi smallint check(GunSayisi>0),
	AktifMi bit 
)
go
create table HizmetPaketleriIndirimTanimlari
(
	HizmetPaketId smallint references HizmetPaketleri(Id),
	IndirimTanimId smallint references IndirimTanimlari(Id),
	constraint PK_HizmetPaketleriIndirimTanimlari primary key(HizmetPaketId,IndirimTanimId)
)
go
create table Calisanlar
(
	Id smallint primary key identity(1,1),
	GorevId tinyint references Gorevler(Id)not null,
	MaasId smallint references Maaslar(Id)not null,
	KanGrubuId tinyint references Kangruplari(Id),
	TcNo bigint not null check (len(TcNo)=11),
	Ad nvarchar(20) not null,
	Soyad nvarchar(30) not null,
	Cinsiyet char(1) not null,
	DogumTarih date not null,
	GirisTarih date not null,
	C�k�sTarihi date,
	Email nvarchar(30)
)
go
create table CalisanTel
(
	Id smallint primary key identity(1,1),
	CalisanId smallint references Calisanlar(Id),
	Tel bigint not null check(len(Tel)=10)
)
go
create table OdemeTipleri
(
	Id tinyint primary key identity(1,1),
	Ad nvarchar(20) not null,
)
go
create table Kasalar
(
	Id smallint primary key references Calisanlar(Id),
	OdemeTipiId tinyint references OdemeTipleri(Id),
	KasaAdi nvarchar(20)not null,
	IslemTutari decimal(7,2) check(IslemTutari>=0),
	IslemTarihSaat datetime
)
go
create table VardiyaPlanlari
(
	Id int primary key identity(1,1),
	CalisanId smallint references Calisanlar(Id)not null,
	VardiyaTipId tinyint references VardiyaTipleri(Id)not null,
	BaslamaTarihi date not null,
	BitisTarihi	date not null
)
go
create table Vardiyalar
(
	Id int primary key identity(1,1),
	CalisanId smallint references Calisanlar(Id) not null,
	BaslamaTarihSaat datetime not null,
	BitisTarihSaat datetime not null
)
go
create table MaasHesaplamalar
(
	CalisanId smallint primary key references Calisanlar(Id),
	Ucret decimal(7,2) not null check (Ucret>0),
)
go
create table Cal�sanAdresler
(
	Id smallint primary key identity(1,1),
	CalisanId smallint references Calisanlar(Id)not null,
	SokakId int references Sokaklar(Id)not null,
	Numara smallint not null
)
go
create table MusteriAdresler
(
	Id int primary key identity(1,1),
	MusteriId int references Musteriler(Id),
	SokakId int references Sokaklar(Id)not null,
	Numara smallint not null
)

go
create table Odalar
(
	Id smallint primary key identity(1,1),
	OdaTipiId tinyint references OdaTipleri(Id)not null,
	Kat tinyint not null
)
go
create table OdaDetaylari
(
	Id smallint primary key identity(1,1),
	OdaId smallint references Odalar(Id)not null,
	YatakTipi nvarchar(20) not null,
	YatakSayisi tinyint not null check (YatakSayisi>0),
)
go
create table Rezervasyonlar
(
	Id int primary key identity(1,1),
	MusteriId int references Musteriler(Id) not null,
	OdaId smallint references Odalar(Id)not null,
	GirisTarih datetime not null,
	C�k�sTarih datetime not null,
	RezervasyonTarih datetime default getdate(),
)
go
create table IndirimTan�mlariRezervasyonlar
(
	RezervasyonId int references Rezervasyonlar(Id),
	IndirimTanimId smallint references IndirimTanimlari(Id),
	constraint PK_IndirimTan�mlariRezervasyonlar primary key(RezervasyonId,IndirimTanimId)
)
go
create table KonaklayanKisiler
(
	Id int primary key identity(1,1),
	RezervasyonId int references Rezervasyonlar(Id)not null,
	Ad nvarchar(20) not null,
	Soyad nvarchar(30) not null,
	Cinsiyet char(1) not null,
	TcNo bigint not null check(TcNo=11),
	Tel bigint check(Tel=10),
)
go
create table Ekstralar
(
	Id int primary key identity(1,1),
	RezervasyonId int references Rezervasyonlar(Id)not null,
	KasaId smallint references Kasalar(Id)not null
)
go
create table Urunler
(
	Id smallint primary key identity(1,1),
	Ad nvarchar(20)not null,
	Fiyat decimal(7,2) not null check(Fiyat>0),
	Stok tinyint
)
go
create table EkstraDetay
(
	Id int primary key identity(1,1),
	EkstraId int references Ekstralar(Id)not null,
	UrunlerId smallint references Urunler(Id)not null,
	Miktar tinyint not null check(Miktar>0)
)
go
create table RezervasyonOdeme
(
	Id int primary key identity(1,1),
	RezervasyonId int references Rezervasyonlar(Id)not null,
	KasaId smallint references Kasalar(Id)not null
)
go
set identity_insert dbo.Ulkeler on 
go
insert into Ulkeler(Id,Ad) values
(1, 'Abhazya'),
(2, 'Afganistan'),
(3, 'Almanya'),
(4, 'Amerika Birle�ik Devletleri'),
(5, 'Andorra'),
(6, 'Angola'),
(7, 'Antigua ve Barbuda'),
(8, 'Arjantin'),
(9, 'Arnavutluk'),
(10, 'Avustralya'),
(11, 'Avusturya'),
(12, 'Azerbaycan'),
(13, 'Bahamalar'),
(14, 'Bahreyn'),
(15, 'Banglade�'),
(16, 'Barbados'),
(17, 'Bat� Sahra'),
(18, 'Belarus'),
(19, 'Bel�ika'),
(20, 'Belize'),
(21, 'Benin'),
(22, 'Bhutan'),
(23, 'Birle�ik Arap Emirlikleri'),
(24, 'Bolivya'),
(25, 'Bosna Hersek'),
(26, 'Botsvana'),
(27, 'Brezilya'),
(28, 'Brunei'),
(29, 'Bulgaristan'),
(30, 'Burkina Faso'),
(31, 'Burundi'),
(32, 'Cezayir'),
(33, 'Cibuti Cumhuriyeti'),
(34, '�ad'),
(35, '�ek Cumhuriyeti'),
(36, '�in Halk Cumhuriyeti'),
(37, 'Da�l�k Karaba� Cumhuriyeti'),
(38, 'Danimarka'),
(39, 'Do�u Timor'),
(40, 'Dominik Cumhuriyeti'),
(41, 'Dominika'),
(42, 'Ekvador'),
(43, 'Ekvator Ginesi'),
(44, 'El Salvador'),
(45, 'Endonezya'),
(46, 'Eritre'),
(47, 'Ermenistan'),
(48, 'Estonya'),
(49, 'Etiyopya'),
(50, 'Fas'),
(51, 'Fiji'),
(52, 'Fildi�i Sahilleri'),
(53, 'Filipinler'),
(54, 'Filistin'),
(55, 'Finlandiya'),
(56, 'Fransa'),
(57, 'Gabon'),
(58, 'Gambiya'),
(59, 'Gana'),
(60, 'Gine Bissau'),
(61, 'Gine'),
(62, 'Grenada'),
(63, 'Guyana'),
(64, 'Guatemala'),
(65, 'G�ney Afrika Cumhuriyeti'),
(66, 'G�ney Kore'),
(67, 'G�ney Osetya'),
(68, 'G�rcistan'),
(69, 'Haiti'),
(70, 'H�rvatistan'),
(71, 'Hindistan'),
(72, 'Hollanda'),
(73, 'Honduras'),
(74, 'Irak'),
(75, '�ngiltere'),
(76, '�ran'),
(77, '�rlanda'),
(78, '�spanya'),
(79, '�srail'),
(80, '�sve�'),
(81, '�svi�re'),
(82, '�talya'),
(83, '�zlanda'),
(84, 'Jamaika'),
(85, 'Japonya'),
(86, 'Kambo�ya'),
(87, 'Kamerun'),
(88, 'Kanada'),
(89, 'Karada�'),
(90, 'Katar'),
(91, 'Kazakistan'),
(92, 'Kenya'),
(93, 'K�rg�zistan'),
(94, 'K�br�s Cumhuriyeti'),
(95, 'Kiribati'),
(96, 'Kolombiya'),
(97, 'Komorlar'),
(98, 'Kongo'),
(99, 'Kongo Demokratik Cumhuriyeti'),
(100, 'Kosova'),
(101, 'Kosta Rika'),
(102, 'Kuveyt'),
(103, 'Kuzey K�br�s T�rk Cumhuriyeti'),
(104, 'Kuzey Kore'),
(105, 'K�ba'),
(106, 'Lakota Cumhuriyeti'),
(107, 'Laos'),
(108, 'Lesotho'),
(109, 'Letonya'),
(110, 'Liberya'),
(111, 'Libya'),
(112, 'Liechtenstein'),
(113, 'Litvanya'),
(114, 'L�bnan'),
(115, 'L�ksemburg'),
(116, 'Macaristan'),
(117, 'Madagaskar'),
(118, 'Makedonya Cumhuriyeti'),
(119, 'Malavi'),
(120, 'Maldivler'),
(121, 'Malezya'),
(122, 'Mali'),
(123, 'Malta'),
(124, 'Marshall Adalar�'),
(125, 'Meksika'),
(126, 'M�s�r'),
(127, 'Mikronezya'),
(128, 'Mo�olistan'),
(129, 'Moldova'),
(130, 'Monako'),
(131, 'Moritanya'),
(132, 'Moritus'),
(133, 'Mozambik'),
(134, 'Myanmar'),
(135, 'Namibya'),
(136, 'Nauru'),
(137, 'Nepal'),
(138, 'Nikaragua'),
(139, 'Nijer'),
(140, 'Nijerya'),
(141, 'Norve�'),
(142, 'Orta Afrika Cumhuriyeti'),
(143, '�zbekistan'),
(144, 'Pakistan'),
(145, 'Palau'),
(146, 'Panama'),
(147, 'Papua Yeni Gine'),
(148, 'Paraguay'),
(149, 'Peru'),
(150, 'Polonya'),
(151, 'Portekiz'),
(152, 'Romanya'),
(153, 'Ruanda'),
(154, 'Rusya Federasyonu'),
(155, 'Saint Kitts ve Nevis'),
(156, 'Saint Lucia'),
(157, 'Saint Vincent ve Grenadinler'),
(158, 'Samoa'),
(159, 'San Marino'),
(160, 'Sao Tome ve Principe'),
(161, 'Sealand'),
(162, 'Senegal'),
(163, 'Sey�eller'),
(164, 'S�rbistan'),
(165, 'Sierra Leone'),
(166, 'Singapur'),
(167, 'Slovakya'),
(168, 'Slovenya'),
(169, 'Solomon Adalar�'),
(170, 'Somali'),
(171, 'Somaliland'),
(172, 'Sri Lanka'),
(173, 'Sudan'),
(174, 'Surinam'),
(175, 'Suudi Arabistan'),
(176, 'Suriye'),
(177, 'Svaziland'),
(178, '�ili'),
(179, 'Tacikistan'),
(180, 'Tamil Eelam'),
(181, 'Tanzanya'),
(182, 'Tayland'),
(183, 'Tayvan'),
(184, 'Togo'),
(185, 'Tonga'),
(186, 'Transdinyester'),
(187, 'Trinidad ve Tobago'),
(188, 'Tunus'),
(189, 'Tuvalu'),
(190, 'T�rkiye'),
(191, 'T�rkmenistan'),
(192, 'Uganda'),
(193, 'Ukrayna'),
(194, 'Umman'),
(195, 'Uruguay'),
(196, '�rd�n'),
(197, 'Vanuatu'),
(198, 'Vatikan'),
(199, 'Venezuela'),
(200, 'Vietnam'),
(201, 'Yemen'),
(202, 'Yeni Zelanda'),
(203, 'Ye�il Burun'),
(204, 'Yunanistan'),
(205, 'Zambiya'),
(206, 'Zimbabve');
go
set identity_insert dbo.Ulkeler off
go
insert into Sehirler(Ad,UlkeId) values ('Adana',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ad�yaman',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Afyonkarahisar',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('A�r�',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Amasya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ankara',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Antalya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Artvin',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ayd�n',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bal�kesir',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bilecik',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bing�l',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bitlis',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bolu',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Burdur',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bursa',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�anakkale',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�ank�r�',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�orum',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Denizli',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Diyarbak�r',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Edirne',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Elaz��',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Erzincan',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Erzurum',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Eski�ehir',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Gaziantep',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Giresun',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('G�m��hane',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Hakk�ri',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Hatay',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Isparta',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mersin',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�stanbul',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�zmir',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kars',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kastamonu',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kayseri',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('K�rklareli',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('K�r�ehir',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kocaeli',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Konya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('K�tahya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Malatya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Manisa',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kahramanmara�',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mardin',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mu�la',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mu�',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Nev�ehir',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ni�de',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ordu',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Rize',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sakarya',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Samsun',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Siirt',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sinop',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sivas',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tekirda�',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tokat',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Trabzon',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tunceli',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('�anl�urfa',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('U�ak',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Van',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Yozgat',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Zonguldak',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Aksaray',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bayburt',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Karaman',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('K�r�kkale',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Batman',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('��rnak',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bart�n',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ardahan',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('I�d�r',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Yalova',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Karab�k',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kilis',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('Osmaniye',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Sehirler(Ad,UlkeId) values ('D�zce',(select Id from Ulkeler where Ad='T�rkiye'))
insert into Ilceler(Ad,SehirId) values ('Seyhan','1') 
insert into Ilceler(Ad,SehirId) values ('Ceyhan','1') 
insert into Ilceler(Ad,SehirId) values ('Feke','1') 
insert into Ilceler(Ad,SehirId) values ('Karaisal�','1') 
insert into Ilceler(Ad,SehirId) values ('Karata�','1') 
insert into Ilceler(Ad,SehirId) values ('Kozan','1') 
insert into Ilceler(Ad,SehirId) values ('Pozant�','1') 
insert into Ilceler(Ad,SehirId) values ('Saimbeyli','1') 
insert into Ilceler(Ad,SehirId) values ('Tufanbeyli','1') 
insert into Ilceler(Ad,SehirId) values ('Yumurtal�k','1') 
insert into Ilceler(Ad,SehirId) values ('Y�re�ir','1') 
insert into Ilceler(Ad,SehirId) values ('Alada�','1') 
insert into Ilceler(Ad,SehirId) values ('�mamo�lu','1') 
insert into Ilceler(Ad,SehirId) values ('Sar��am','1') 
insert into Ilceler(Ad,SehirId) values ('�ukurova','1') 
insert into Ilceler(Ad,SehirId) values ('Ad�yaman Merkez','2') 
insert into Ilceler(Ad,SehirId) values ('Besni','2') 
insert into Ilceler(Ad,SehirId) values ('�elikhan','2') 
insert into Ilceler(Ad,SehirId) values ('Gerger','2') 
insert into Ilceler(Ad,SehirId) values ('G�lba�� / Ad�yaman','2') 
insert into Ilceler(Ad,SehirId) values ('Kahta','2') 
insert into Ilceler(Ad,SehirId) values ('Samsat','2') 
insert into Ilceler(Ad,SehirId) values ('Sincik','2') 
insert into Ilceler(Ad,SehirId) values ('Tut','2') 
insert into Ilceler(Ad,SehirId) values ('Afyonkarahisar Merkez','3') 
insert into Ilceler(Ad,SehirId) values ('Bolvadin','3') 
insert into Ilceler(Ad,SehirId) values ('�ay','3') 
insert into Ilceler(Ad,SehirId) values ('Dazk�r�','3') 
insert into Ilceler(Ad,SehirId) values ('Dinar','3') 
insert into Ilceler(Ad,SehirId) values ('Emirda�','3') 
insert into Ilceler(Ad,SehirId) values ('�hsaniye','3') 
insert into Ilceler(Ad,SehirId) values ('Sand�kl�','3') 
insert into Ilceler(Ad,SehirId) values ('Sinanpa�a','3') 
insert into Ilceler(Ad,SehirId) values ('Sultanda��','3') 
insert into Ilceler(Ad,SehirId) values ('�uhut','3') 
insert into Ilceler(Ad,SehirId) values ('Ba�mak��','3') 
insert into Ilceler(Ad,SehirId) values ('Bayat / Afyonkarahisar','3') 
insert into Ilceler(Ad,SehirId) values ('�scehisar','3') 
insert into Ilceler(Ad,SehirId) values ('�obanlar','3') 
insert into Ilceler(Ad,SehirId) values ('Evciler','3') 
insert into Ilceler(Ad,SehirId) values ('Hocalar','3') 
insert into Ilceler(Ad,SehirId) values ('K�z�l�ren','3') 
insert into Ilceler(Ad,SehirId) values ('A�r� Merkez','4') 
insert into Ilceler(Ad,SehirId) values ('Diyadin','4') 
insert into Ilceler(Ad,SehirId) values ('Do�ubayaz�t','4') 
insert into Ilceler(Ad,SehirId) values ('Ele�kirt','4') 
insert into Ilceler(Ad,SehirId) values ('Hamur','4') 
insert into Ilceler(Ad,SehirId) values ('Patnos','4') 
insert into Ilceler(Ad,SehirId) values ('Ta�l��ay','4') 
insert into Ilceler(Ad,SehirId) values ('Tutak','4') 
insert into Ilceler(Ad,SehirId) values ('Amasya Merkez','5') 
insert into Ilceler(Ad,SehirId) values ('G�yn�cek','5') 
insert into Ilceler(Ad,SehirId) values ('G�m��hac�k�y','5') 
insert into Ilceler(Ad,SehirId) values ('Merzifon','5') 
insert into Ilceler(Ad,SehirId) values ('Suluova','5') 
insert into Ilceler(Ad,SehirId) values ('Ta�ova','5') 
insert into Ilceler(Ad,SehirId) values ('Hamam�z�','5') 
insert into Ilceler(Ad,SehirId) values ('Alt�nda�','6') 
insert into Ilceler(Ad,SehirId) values ('Aya�','6') 
insert into Ilceler(Ad,SehirId) values ('Bala','6') 
insert into Ilceler(Ad,SehirId) values ('Beypazar�','6') 
insert into Ilceler(Ad,SehirId) values ('�aml�dere','6') 
insert into Ilceler(Ad,SehirId) values ('�ankaya','6') 
insert into Ilceler(Ad,SehirId) values ('�ubuk','6') 
insert into Ilceler(Ad,SehirId) values ('Elmada�','6') 
insert into Ilceler(Ad,SehirId) values ('G�d�l','6') 
insert into Ilceler(Ad,SehirId) values ('Haymana','6') 
insert into Ilceler(Ad,SehirId) values ('Kalecik','6') 
insert into Ilceler(Ad,SehirId) values ('K�z�lcahamam','6') 
insert into Ilceler(Ad,SehirId) values ('Nall�han','6') 
insert into Ilceler(Ad,SehirId) values ('Polatl�','6') 
insert into Ilceler(Ad,SehirId) values ('�erefliko�hisar','6') 
insert into Ilceler(Ad,SehirId) values ('Yenimahalle','6') 
insert into Ilceler(Ad,SehirId) values ('G�lba�� / Ankara','6') 
insert into Ilceler(Ad,SehirId) values ('Ke�i�ren','6') 
insert into Ilceler(Ad,SehirId) values ('Mamak','6') 
insert into Ilceler(Ad,SehirId) values ('Sincan','6') 
insert into Ilceler(Ad,SehirId) values ('Kazan','6') 
insert into Ilceler(Ad,SehirId) values ('Akyurt','6') 
insert into Ilceler(Ad,SehirId) values ('Etimesgut','6') 
insert into Ilceler(Ad,SehirId) values ('Evren','6') 
insert into Ilceler(Ad,SehirId) values ('Pursaklar','6') 
insert into Ilceler(Ad,SehirId) values ('Akseki','7') 
insert into Ilceler(Ad,SehirId) values ('Alanya','7') 
insert into Ilceler(Ad,SehirId) values ('Elmal�','7') 
insert into Ilceler(Ad,SehirId) values ('Finike','7') 
insert into Ilceler(Ad,SehirId) values ('Gazipa�a','7') 
insert into Ilceler(Ad,SehirId) values ('G�ndo�mu�','7') 
insert into Ilceler(Ad,SehirId) values ('Ka�','7') 
insert into Ilceler(Ad,SehirId) values ('Korkuteli','7') 
insert into Ilceler(Ad,SehirId) values ('Kumluca','7') 
insert into Ilceler(Ad,SehirId) values ('Manavgat','7') 
insert into Ilceler(Ad,SehirId) values ('Serik','7') 
insert into Ilceler(Ad,SehirId) values ('Demre','7') 
insert into Ilceler(Ad,SehirId) values ('�brad�','7') 
insert into Ilceler(Ad,SehirId) values ('Kemer / Antalya','7') 
insert into Ilceler(Ad,SehirId) values ('Aksu / Antalya','7') 
insert into Ilceler(Ad,SehirId) values ('D��emealt�','7') 
insert into Ilceler(Ad,SehirId) values ('Kepez','7') 
insert into Ilceler(Ad,SehirId) values ('Konyaalt�','7') 
insert into Ilceler(Ad,SehirId) values ('Muratpa�a','7') 
insert into Ilceler(Ad,SehirId) values ('Ardanu�','8') 
insert into Ilceler(Ad,SehirId) values ('Arhavi','8') 
insert into Ilceler(Ad,SehirId) values ('Artvin Merkez','8') 
insert into Ilceler(Ad,SehirId) values ('Bor�ka','8') 
insert into Ilceler(Ad,SehirId) values ('Hopa','8') 
insert into Ilceler(Ad,SehirId) values ('�av�at','8') 
insert into Ilceler(Ad,SehirId) values ('Yusufeli','8') 
insert into Ilceler(Ad,SehirId) values ('Murgul','8') 
insert into Ilceler(Ad,SehirId) values ('Bozdo�an','9') 
insert into Ilceler(Ad,SehirId) values ('�ine','9') 
insert into Ilceler(Ad,SehirId) values ('Germencik','9') 
insert into Ilceler(Ad,SehirId) values ('Karacasu','9') 
insert into Ilceler(Ad,SehirId) values ('Ko�arl�','9') 
insert into Ilceler(Ad,SehirId) values ('Ku�adas�','9') 
insert into Ilceler(Ad,SehirId) values ('Kuyucak','9') 
insert into Ilceler(Ad,SehirId) values ('Nazilli','9') 
insert into Ilceler(Ad,SehirId) values ('S�ke','9') 
insert into Ilceler(Ad,SehirId) values ('Sultanhisar','9') 
insert into Ilceler(Ad,SehirId) values ('Yenipazar / Ayd�n','9') 
insert into Ilceler(Ad,SehirId) values ('Buharkent','9') 
insert into Ilceler(Ad,SehirId) values ('�ncirliova','9') 
insert into Ilceler(Ad,SehirId) values ('Karpuzlu','9') 
insert into Ilceler(Ad,SehirId) values ('K��k','9') 
insert into Ilceler(Ad,SehirId) values ('Didim','9') 
insert into Ilceler(Ad,SehirId) values ('Efeler','9') 
insert into Ilceler(Ad,SehirId) values ('Ayval�k','10') 
insert into Ilceler(Ad,SehirId) values ('Balya','10') 
insert into Ilceler(Ad,SehirId) values ('Band�rma','10') 
insert into Ilceler(Ad,SehirId) values ('Bigadi�','10') 
insert into Ilceler(Ad,SehirId) values ('Burhaniye','10') 
insert into Ilceler(Ad,SehirId) values ('Dursunbey','10') 
insert into Ilceler(Ad,SehirId) values ('Edremit / Bal�kesir','10') 
insert into Ilceler(Ad,SehirId) values ('Erdek','10') 
insert into Ilceler(Ad,SehirId) values ('G�nen / Bal�kesir','10') 
insert into Ilceler(Ad,SehirId) values ('Havran','10') 
insert into Ilceler(Ad,SehirId) values ('�vrindi','10') 
insert into Ilceler(Ad,SehirId) values ('Kepsut','10') 
insert into Ilceler(Ad,SehirId) values ('Manyas','10') 
insert into Ilceler(Ad,SehirId) values ('Sava�tepe','10') 
insert into Ilceler(Ad,SehirId) values ('S�nd�rg�','10') 
insert into Ilceler(Ad,SehirId) values ('Susurluk','10') 
insert into Ilceler(Ad,SehirId) values ('Marmara','10') 
insert into Ilceler(Ad,SehirId) values ('G�me�','10') 
insert into Ilceler(Ad,SehirId) values ('Alt�eyl�l','10') 
insert into Ilceler(Ad,SehirId) values ('Karesi','10') 
insert into Ilceler(Ad,SehirId) values ('Bilecik Merkez','11') 
insert into Ilceler(Ad,SehirId) values ('Boz�y�k','11') 
insert into Ilceler(Ad,SehirId) values ('G�lpazar�','11') 
insert into Ilceler(Ad,SehirId) values ('Osmaneli','11') 
insert into Ilceler(Ad,SehirId) values ('Pazaryeri','11') 
insert into Ilceler(Ad,SehirId) values ('S���t','11') 
insert into Ilceler(Ad,SehirId) values ('Yenipazar / Bilecik','11') 
insert into Ilceler(Ad,SehirId) values ('�nhisar','11') 
insert into Ilceler(Ad,SehirId) values ('Bing�l Merkez','12') 
insert into Ilceler(Ad,SehirId) values ('Gen�','12') 
insert into Ilceler(Ad,SehirId) values ('Karl�ova','12') 
insert into Ilceler(Ad,SehirId) values ('Ki��','12') 
insert into Ilceler(Ad,SehirId) values ('Solhan','12') 
insert into Ilceler(Ad,SehirId) values ('Adakl�','12') 
insert into Ilceler(Ad,SehirId) values ('Yayladere','12') 
insert into Ilceler(Ad,SehirId) values ('Yedisu','12') 
insert into Ilceler(Ad,SehirId) values ('Adilcevaz','13') 
insert into Ilceler(Ad,SehirId) values ('Ahlat','13') 
insert into Ilceler(Ad,SehirId) values ('Bitlis Merkez','13') 
insert into Ilceler(Ad,SehirId) values ('Hizan','13') 
insert into Ilceler(Ad,SehirId) values ('Mutki','13') 
insert into Ilceler(Ad,SehirId) values ('Tatvan','13') 
insert into Ilceler(Ad,SehirId) values ('G�roymak','13') 
insert into Ilceler(Ad,SehirId) values ('Bolu Merkez','14') 
insert into Ilceler(Ad,SehirId) values ('Gerede','14') 
insert into Ilceler(Ad,SehirId) values ('G�yn�k','14') 
insert into Ilceler(Ad,SehirId) values ('K�br�sc�k','14') 
insert into Ilceler(Ad,SehirId) values ('Mengen','14') 
insert into Ilceler(Ad,SehirId) values ('Mudurnu','14') 
insert into Ilceler(Ad,SehirId) values ('Seben','14') 
insert into Ilceler(Ad,SehirId) values ('D�rtdivan','14') 
insert into Ilceler(Ad,SehirId) values ('Yeni�a�a','14') 
insert into Ilceler(Ad,SehirId) values ('A�lasun','15') 
insert into Ilceler(Ad,SehirId) values ('Bucak','15') 
insert into Ilceler(Ad,SehirId) values ('Burdur Merkez','15') 
insert into Ilceler(Ad,SehirId) values ('G�lhisar','15') 
insert into Ilceler(Ad,SehirId) values ('Tefenni','15') 
insert into Ilceler(Ad,SehirId) values ('Ye�ilova','15') 
insert into Ilceler(Ad,SehirId) values ('Karamanl�','15') 
insert into Ilceler(Ad,SehirId) values ('Kemer / Burdur','15') 
insert into Ilceler(Ad,SehirId) values ('Alt�nyayla / Burdur','15') 
insert into Ilceler(Ad,SehirId) values ('�avd�r','15') 
insert into Ilceler(Ad,SehirId) values ('�eltik�i','15') 
insert into Ilceler(Ad,SehirId) values ('Gemlik','16') 
insert into Ilceler(Ad,SehirId) values ('�neg�l','16') 
insert into Ilceler(Ad,SehirId) values ('�znik','16') 
insert into Ilceler(Ad,SehirId) values ('Karacabey','16') 
insert into Ilceler(Ad,SehirId) values ('Keles','16') 
insert into Ilceler(Ad,SehirId) values ('Mudanya','16') 
insert into Ilceler(Ad,SehirId) values ('Mustafakemalpa�a','16') 
insert into Ilceler(Ad,SehirId) values ('Orhaneli','16') 
insert into Ilceler(Ad,SehirId) values ('Orhangazi','16') 
insert into Ilceler(Ad,SehirId) values ('Yeni�ehir / Bursa','16') 
insert into Ilceler(Ad,SehirId) values ('B�y�korhan','16') 
insert into Ilceler(Ad,SehirId) values ('Harmanc�k','16') 
insert into Ilceler(Ad,SehirId) values ('Nil�fer','16') 
insert into Ilceler(Ad,SehirId) values ('Osmangazi','16') 
insert into Ilceler(Ad,SehirId) values ('Y�ld�r�m','16') 
insert into Ilceler(Ad,SehirId) values ('G�rsu','16') 
insert into Ilceler(Ad,SehirId) values ('Kestel','16') 
insert into Ilceler(Ad,SehirId) values ('Ayvac�k / �anakkale','17') 
insert into Ilceler(Ad,SehirId) values ('Bayrami�','17') 
insert into Ilceler(Ad,SehirId) values ('Biga','17') 
insert into Ilceler(Ad,SehirId) values ('Bozcaada','17') 
insert into Ilceler(Ad,SehirId) values ('�an','17') 
insert into Ilceler(Ad,SehirId) values ('�anakkale Merkez','17') 
insert into Ilceler(Ad,SehirId) values ('Eceabat','17') 
insert into Ilceler(Ad,SehirId) values ('Ezine','17') 
insert into Ilceler(Ad,SehirId) values ('Gelibolu','17') 
insert into Ilceler(Ad,SehirId) values ('G�k�eada','17') 
insert into Ilceler(Ad,SehirId) values ('Lapseki','17') 
insert into Ilceler(Ad,SehirId) values ('Yenice / �anakkale','17') 
insert into Ilceler(Ad,SehirId) values ('�ank�r� Merkez','18') 
insert into Ilceler(Ad,SehirId) values ('�erke�','18') 
insert into Ilceler(Ad,SehirId) values ('Eldivan','18') 
insert into Ilceler(Ad,SehirId) values ('Ilgaz','18') 
insert into Ilceler(Ad,SehirId) values ('Kur�unlu','18') 
insert into Ilceler(Ad,SehirId) values ('Orta','18') 
insert into Ilceler(Ad,SehirId) values ('�aban�z�','18') 
insert into Ilceler(Ad,SehirId) values ('Yaprakl�','18') 
insert into Ilceler(Ad,SehirId) values ('Atkaracalar','18') 
insert into Ilceler(Ad,SehirId) values ('K�z�l�rmak','18') 
insert into Ilceler(Ad,SehirId) values ('Bayram�ren','18') 
insert into Ilceler(Ad,SehirId) values ('Korgun','18') 
insert into Ilceler(Ad,SehirId) values ('Alaca','19') 
insert into Ilceler(Ad,SehirId) values ('Bayat / �orum','19') 
insert into Ilceler(Ad,SehirId) values ('�orum Merkez','19') 
insert into Ilceler(Ad,SehirId) values ('�skilip','19') 
insert into Ilceler(Ad,SehirId) values ('Karg�','19') 
insert into Ilceler(Ad,SehirId) values ('Mecit�z�','19') 
insert into Ilceler(Ad,SehirId) values ('Ortak�y / �orum','19') 
insert into Ilceler(Ad,SehirId) values ('Osmanc�k','19') 
insert into Ilceler(Ad,SehirId) values ('Sungurlu','19') 
insert into Ilceler(Ad,SehirId) values ('Bo�azkale','19') 
insert into Ilceler(Ad,SehirId) values ('U�urluda�','19') 
insert into Ilceler(Ad,SehirId) values ('Dodurga','19') 
insert into Ilceler(Ad,SehirId) values ('La�in','19') 
insert into Ilceler(Ad,SehirId) values ('O�uzlar','19') 
insert into Ilceler(Ad,SehirId) values ('Ac�payam','20') 
insert into Ilceler(Ad,SehirId) values ('Buldan','20') 
insert into Ilceler(Ad,SehirId) values ('�al','20') 
insert into Ilceler(Ad,SehirId) values ('�ameli','20') 
insert into Ilceler(Ad,SehirId) values ('�ardak','20') 
insert into Ilceler(Ad,SehirId) values ('�ivril','20') 
insert into Ilceler(Ad,SehirId) values ('G�ney','20') 
insert into Ilceler(Ad,SehirId) values ('Kale / Denizli','20') 
insert into Ilceler(Ad,SehirId) values ('Sarayk�y','20') 
insert into Ilceler(Ad,SehirId) values ('Tavas','20') 
insert into Ilceler(Ad,SehirId) values ('Babada�','20') 
insert into Ilceler(Ad,SehirId) values ('Bekilli','20') 
insert into Ilceler(Ad,SehirId) values ('Honaz','20') 
insert into Ilceler(Ad,SehirId) values ('Serinhisar','20') 
insert into Ilceler(Ad,SehirId) values ('Pamukkale','20') 
insert into Ilceler(Ad,SehirId) values ('Baklan','20') 
insert into Ilceler(Ad,SehirId) values ('Beya�a�','20') 
insert into Ilceler(Ad,SehirId) values ('Bozkurt / Denizli','20') 
insert into Ilceler(Ad,SehirId) values ('Merkezefendi','20') 
insert into Ilceler(Ad,SehirId) values ('Bismil','21') 
insert into Ilceler(Ad,SehirId) values ('�ermik','21') 
insert into Ilceler(Ad,SehirId) values ('��nar','21') 
insert into Ilceler(Ad,SehirId) values ('��ng��','21') 
insert into Ilceler(Ad,SehirId) values ('Dicle','21') 
insert into Ilceler(Ad,SehirId) values ('Ergani','21') 
insert into Ilceler(Ad,SehirId) values ('Hani','21') 
insert into Ilceler(Ad,SehirId) values ('Hazro','21') 
insert into Ilceler(Ad,SehirId) values ('Kulp','21') 
insert into Ilceler(Ad,SehirId) values ('Lice','21') 
insert into Ilceler(Ad,SehirId) values ('Silvan','21') 
insert into Ilceler(Ad,SehirId) values ('E�il','21') 
insert into Ilceler(Ad,SehirId) values ('Kocak�y','21') 
insert into Ilceler(Ad,SehirId) values ('Ba�lar','21') 
insert into Ilceler(Ad,SehirId) values ('Kayap�nar','21') 
insert into Ilceler(Ad,SehirId) values ('Sur','21') 
insert into Ilceler(Ad,SehirId) values ('Yeni�ehir / Diyarbak�r','21') 
insert into Ilceler(Ad,SehirId) values ('Edirne Merkez','22') 
insert into Ilceler(Ad,SehirId) values ('Enez','22') 
insert into Ilceler(Ad,SehirId) values ('Havsa','22') 
insert into Ilceler(Ad,SehirId) values ('�psala','22') 
insert into Ilceler(Ad,SehirId) values ('Ke�an','22') 
insert into Ilceler(Ad,SehirId) values ('Lalapa�a','22') 
insert into Ilceler(Ad,SehirId) values ('Meri�','22') 
insert into Ilceler(Ad,SehirId) values ('Uzunk�pr�','22') 
insert into Ilceler(Ad,SehirId) values ('S�lo�lu','22') 
insert into Ilceler(Ad,SehirId) values ('A��n','23') 
insert into Ilceler(Ad,SehirId) values ('Baskil','23') 
insert into Ilceler(Ad,SehirId) values ('Elaz�� Merkez','23') 
insert into Ilceler(Ad,SehirId) values ('Karako�an','23') 
insert into Ilceler(Ad,SehirId) values ('Keban','23') 
insert into Ilceler(Ad,SehirId) values ('Maden','23') 
insert into Ilceler(Ad,SehirId) values ('Palu','23') 
insert into Ilceler(Ad,SehirId) values ('Sivrice','23') 
insert into Ilceler(Ad,SehirId) values ('Ar�cak','23') 
insert into Ilceler(Ad,SehirId) values ('Kovanc�lar','23') 
insert into Ilceler(Ad,SehirId) values ('Alacakaya','23') 
insert into Ilceler(Ad,SehirId) values ('�ay�rl�','24') 
insert into Ilceler(Ad,SehirId) values ('Erzincan Merkez','24') 
insert into Ilceler(Ad,SehirId) values ('�li�','24') 
insert into Ilceler(Ad,SehirId) values ('Kemah','24') 
insert into Ilceler(Ad,SehirId) values ('Kemaliye','24') 
insert into Ilceler(Ad,SehirId) values ('Refahiye','24') 
insert into Ilceler(Ad,SehirId) values ('Tercan','24') 
insert into Ilceler(Ad,SehirId) values ('�z�ml�','24') 
insert into Ilceler(Ad,SehirId) values ('Otlukbeli','24') 
insert into Ilceler(Ad,SehirId) values ('A�kale','25') 
insert into Ilceler(Ad,SehirId) values ('�at','25') 
insert into Ilceler(Ad,SehirId) values ('H�n�s','25') 
insert into Ilceler(Ad,SehirId) values ('Horasan','25') 
insert into Ilceler(Ad,SehirId) values ('�spir','25') 
insert into Ilceler(Ad,SehirId) values ('Karayaz�','25') 
insert into Ilceler(Ad,SehirId) values ('Narman','25') 
insert into Ilceler(Ad,SehirId) values ('Oltu','25') 
insert into Ilceler(Ad,SehirId) values ('Olur','25') 
insert into Ilceler(Ad,SehirId) values ('Pasinler','25') 
insert into Ilceler(Ad,SehirId) values ('�enkaya','25') 
insert into Ilceler(Ad,SehirId) values ('Tekman','25') 
insert into Ilceler(Ad,SehirId) values ('Tortum','25') 
insert into Ilceler(Ad,SehirId) values ('Kara�oban','25') 
insert into Ilceler(Ad,SehirId) values ('Uzundere','25') 
insert into Ilceler(Ad,SehirId) values ('Pazaryolu','25') 
insert into Ilceler(Ad,SehirId) values ('Aziziye','25') 
insert into Ilceler(Ad,SehirId) values ('K�pr�k�y','25') 
insert into Ilceler(Ad,SehirId) values ('Paland�ken','25') 
insert into Ilceler(Ad,SehirId) values ('Yakutiye','25') 
insert into Ilceler(Ad,SehirId) values ('�ifteler','26') 
insert into Ilceler(Ad,SehirId) values ('Mahmudiye','26') 
insert into Ilceler(Ad,SehirId) values ('Mihal����k','26') 
insert into Ilceler(Ad,SehirId) values ('Sar�cakaya','26') 
insert into Ilceler(Ad,SehirId) values ('Seyitgazi','26') 
insert into Ilceler(Ad,SehirId) values ('Sivrihisar','26') 
insert into Ilceler(Ad,SehirId) values ('Alpu','26') 
insert into Ilceler(Ad,SehirId) values ('Beylikova','26') 
insert into Ilceler(Ad,SehirId) values ('�n�n�','26') 
insert into Ilceler(Ad,SehirId) values ('G�ny�z�','26') 
insert into Ilceler(Ad,SehirId) values ('Han','26') 
insert into Ilceler(Ad,SehirId) values ('Mihalgazi','26') 
insert into Ilceler(Ad,SehirId) values ('Odunpazar�','26') 
insert into Ilceler(Ad,SehirId) values ('Tepeba��','26') 
insert into Ilceler(Ad,SehirId) values ('Araban','27') 
insert into Ilceler(Ad,SehirId) values ('�slahiye','27') 
insert into Ilceler(Ad,SehirId) values ('Nizip','27') 
insert into Ilceler(Ad,SehirId) values ('O�uzeli','27') 
insert into Ilceler(Ad,SehirId) values ('Yavuzeli','27') 
insert into Ilceler(Ad,SehirId) values ('�ahinbey','27') 
insert into Ilceler(Ad,SehirId) values ('�ehitkamil','27') 
insert into Ilceler(Ad,SehirId) values ('Karkam��','27') 
insert into Ilceler(Ad,SehirId) values ('Nurda��','27') 
insert into Ilceler(Ad,SehirId) values ('Alucra','28') 
insert into Ilceler(Ad,SehirId) values ('Bulancak','28') 
insert into Ilceler(Ad,SehirId) values ('Dereli','28') 
insert into Ilceler(Ad,SehirId) values ('Espiye','28') 
insert into Ilceler(Ad,SehirId) values ('Eynesil','28') 
insert into Ilceler(Ad,SehirId) values ('Giresun Merkez','28') 
insert into Ilceler(Ad,SehirId) values ('G�rele','28') 
insert into Ilceler(Ad,SehirId) values ('Ke�ap','28') 
insert into Ilceler(Ad,SehirId) values ('�ebinkarahisar','28') 
insert into Ilceler(Ad,SehirId) values ('Tirebolu','28') 
insert into Ilceler(Ad,SehirId) values ('Piraziz','28') 
insert into Ilceler(Ad,SehirId) values ('Ya�l�dere','28') 
insert into Ilceler(Ad,SehirId) values ('�amoluk','28') 
insert into Ilceler(Ad,SehirId) values ('�anak��','28') 
insert into Ilceler(Ad,SehirId) values ('Do�ankent','28') 
insert into Ilceler(Ad,SehirId) values ('G�ce','28') 
insert into Ilceler(Ad,SehirId) values ('G�m��hane Merkez','29') 
insert into Ilceler(Ad,SehirId) values ('Kelkit','29') 
insert into Ilceler(Ad,SehirId) values ('�iran','29') 
insert into Ilceler(Ad,SehirId) values ('Torul','29') 
insert into Ilceler(Ad,SehirId) values ('K�se','29') 
insert into Ilceler(Ad,SehirId) values ('K�rt�n','29') 
insert into Ilceler(Ad,SehirId) values ('�ukurca','30') 
insert into Ilceler(Ad,SehirId) values ('Hakkari Merkez','30') 
insert into Ilceler(Ad,SehirId) values ('�emdinli','30') 
insert into Ilceler(Ad,SehirId) values ('Y�ksekova','30') 
insert into Ilceler(Ad,SehirId) values ('Alt�n�z�','31') 
insert into Ilceler(Ad,SehirId) values ('D�rtyol','31') 
insert into Ilceler(Ad,SehirId) values ('Hassa','31') 
insert into Ilceler(Ad,SehirId) values ('�skenderun','31') 
insert into Ilceler(Ad,SehirId) values ('K�r�khan','31') 
insert into Ilceler(Ad,SehirId) values ('Reyhanl�','31') 
insert into Ilceler(Ad,SehirId) values ('Samanda�','31') 
insert into Ilceler(Ad,SehirId) values ('Yaylada��','31') 
insert into Ilceler(Ad,SehirId) values ('Erzin','31') 
insert into Ilceler(Ad,SehirId) values ('Belen','31') 
insert into Ilceler(Ad,SehirId) values ('Kumlu','31') 
insert into Ilceler(Ad,SehirId) values ('Antakya','31') 
insert into Ilceler(Ad,SehirId) values ('Arsuz','31') 
insert into Ilceler(Ad,SehirId) values ('Defne','31') 
insert into Ilceler(Ad,SehirId) values ('Payas','31') 
insert into Ilceler(Ad,SehirId) values ('Atabey','32') 
insert into Ilceler(Ad,SehirId) values ('E�irdir','32') 
insert into Ilceler(Ad,SehirId) values ('Gelendost','32') 
insert into Ilceler(Ad,SehirId) values ('Isparta Merkez','32') 
insert into Ilceler(Ad,SehirId) values ('Ke�iborlu','32') 
insert into Ilceler(Ad,SehirId) values ('Senirkent','32') 
insert into Ilceler(Ad,SehirId) values ('S�t��ler','32') 
insert into Ilceler(Ad,SehirId) values ('�arkikaraa�a�','32') 
insert into Ilceler(Ad,SehirId) values ('Uluborlu','32') 
insert into Ilceler(Ad,SehirId) values ('Yalva�','32') 
insert into Ilceler(Ad,SehirId) values ('Aksu / Isparta','32') 
insert into Ilceler(Ad,SehirId) values ('G�nen / Isparta','32') 
insert into Ilceler(Ad,SehirId) values ('Yeni�arbademli','32') 
insert into Ilceler(Ad,SehirId) values ('Anamur','33') 
insert into Ilceler(Ad,SehirId) values ('Erdemli','33') 
insert into Ilceler(Ad,SehirId) values ('G�lnar','33') 
insert into Ilceler(Ad,SehirId) values ('Mut','33') 
insert into Ilceler(Ad,SehirId) values ('Silifke','33') 
insert into Ilceler(Ad,SehirId) values ('Tarsus','33') 
insert into Ilceler(Ad,SehirId) values ('Ayd�nc�k / Mersin','33') 
insert into Ilceler(Ad,SehirId) values ('Bozyaz�','33') 
insert into Ilceler(Ad,SehirId) values ('�aml�yayla','33') 
insert into Ilceler(Ad,SehirId) values ('Akdeniz','33') 
insert into Ilceler(Ad,SehirId) values ('Mezitli','33') 
insert into Ilceler(Ad,SehirId) values ('Toroslar','33') 
insert into Ilceler(Ad,SehirId) values ('Yeni�ehir / Mersin','33') 
insert into Ilceler(Ad,SehirId) values ('Adalar','34') 
insert into Ilceler(Ad,SehirId) values ('Bak�rk�y','34') 
insert into Ilceler(Ad,SehirId) values ('Be�ikta�','34') 
insert into Ilceler(Ad,SehirId) values ('Beykoz','34') 
insert into Ilceler(Ad,SehirId) values ('Beyo�lu','34') 
insert into Ilceler(Ad,SehirId) values ('�atalca','34') 
insert into Ilceler(Ad,SehirId) values ('Ey�p','34') 
insert into Ilceler(Ad,SehirId) values ('Fatih','34') 
insert into Ilceler(Ad,SehirId) values ('Gaziosmanpa�a','34') 
insert into Ilceler(Ad,SehirId) values ('Kad�k�y','34') 
insert into Ilceler(Ad,SehirId) values ('Kartal','34') 
insert into Ilceler(Ad,SehirId) values ('Sar�yer','34') 
insert into Ilceler(Ad,SehirId) values ('Silivri','34') 
insert into Ilceler(Ad,SehirId) values ('�ile','34') 
insert into Ilceler(Ad,SehirId) values ('�i�li','34') 
insert into Ilceler(Ad,SehirId) values ('�sk�dar','34') 
insert into Ilceler(Ad,SehirId) values ('Zeytinburnu','34') 
insert into Ilceler(Ad,SehirId) values ('B�y�k�ekmece','34') 
insert into Ilceler(Ad,SehirId) values ('Ka��thane','34') 
insert into Ilceler(Ad,SehirId) values ('K���k�ekmece','34') 
insert into Ilceler(Ad,SehirId) values ('Pendik','34') 
insert into Ilceler(Ad,SehirId) values ('�mraniye','34') 
insert into Ilceler(Ad,SehirId) values ('Bayrampa�a','34') 
insert into Ilceler(Ad,SehirId) values ('Avc�lar','34') 
insert into Ilceler(Ad,SehirId) values ('Ba�c�lar','34') 
insert into Ilceler(Ad,SehirId) values ('Bah�elievler','34') 
insert into Ilceler(Ad,SehirId) values ('G�ng�ren','34') 
insert into Ilceler(Ad,SehirId) values ('Maltepe','34') 
insert into Ilceler(Ad,SehirId) values ('Sultanbeyli','34') 
insert into Ilceler(Ad,SehirId) values ('Tuzla','34') 
insert into Ilceler(Ad,SehirId) values ('Esenler','34') 
insert into Ilceler(Ad,SehirId) values ('Arnavutk�y','34') 
insert into Ilceler(Ad,SehirId) values ('Ata�ehir','34') 
insert into Ilceler(Ad,SehirId) values ('Ba�ak�ehir','34') 
insert into Ilceler(Ad,SehirId) values ('Beylikd�z�','34') 
insert into Ilceler(Ad,SehirId) values ('�ekmek�y','34') 
insert into Ilceler(Ad,SehirId) values ('Esenyurt','34') 
insert into Ilceler(Ad,SehirId) values ('Sancaktepe','34') 
insert into Ilceler(Ad,SehirId) values ('Sultangazi','34') 
insert into Ilceler(Ad,SehirId) values ('Alia�a','35') 
insert into Ilceler(Ad,SehirId) values ('Bay�nd�r','35') 
insert into Ilceler(Ad,SehirId) values ('Bergama','35') 
insert into Ilceler(Ad,SehirId) values ('Bornova','35') 
insert into Ilceler(Ad,SehirId) values ('�e�me','35') 
insert into Ilceler(Ad,SehirId) values ('Dikili','35') 
insert into Ilceler(Ad,SehirId) values ('Fo�a','35') 
insert into Ilceler(Ad,SehirId) values ('Karaburun','35') 
insert into Ilceler(Ad,SehirId) values ('Kar��yaka','35') 
insert into Ilceler(Ad,SehirId) values ('Kemalpa�a / �zmir','35') 
insert into Ilceler(Ad,SehirId) values ('K�n�k','35') 
insert into Ilceler(Ad,SehirId) values ('Kiraz','35') 
insert into Ilceler(Ad,SehirId) values ('Menemen','35') 
insert into Ilceler(Ad,SehirId) values ('�demi�','35') 
insert into Ilceler(Ad,SehirId) values ('Seferihisar','35') 
insert into Ilceler(Ad,SehirId) values ('Sel�uk','35') 
insert into Ilceler(Ad,SehirId) values ('Tire','35') 
insert into Ilceler(Ad,SehirId) values ('Torbal�','35') 
insert into Ilceler(Ad,SehirId) values ('Urla','35') 
insert into Ilceler(Ad,SehirId) values ('Beyda�','35') 
insert into Ilceler(Ad,SehirId) values ('Buca','35') 
insert into Ilceler(Ad,SehirId) values ('Konak','35') 
insert into Ilceler(Ad,SehirId) values ('Menderes','35') 
insert into Ilceler(Ad,SehirId) values ('Bal�ova','35') 
insert into Ilceler(Ad,SehirId) values ('�i�li','35') 
insert into Ilceler(Ad,SehirId) values ('Gaziemir','35') 
insert into Ilceler(Ad,SehirId) values ('Narl�dere','35') 
insert into Ilceler(Ad,SehirId) values ('G�zelbah�e','35') 
insert into Ilceler(Ad,SehirId) values ('Bayrakl�','35') 
insert into Ilceler(Ad,SehirId) values ('Karaba�lar','35') 
insert into Ilceler(Ad,SehirId) values ('Arpa�ay','36') 
insert into Ilceler(Ad,SehirId) values ('Digor','36') 
insert into Ilceler(Ad,SehirId) values ('Ka��zman','36') 
insert into Ilceler(Ad,SehirId) values ('Kars Merkez','36') 
insert into Ilceler(Ad,SehirId) values ('Sar�kam��','36') 
insert into Ilceler(Ad,SehirId) values ('Selim','36') 
insert into Ilceler(Ad,SehirId) values ('Susuz','36') 
insert into Ilceler(Ad,SehirId) values ('Akyaka','36') 
insert into Ilceler(Ad,SehirId) values ('Abana','37') 
insert into Ilceler(Ad,SehirId) values ('Ara�','37') 
insert into Ilceler(Ad,SehirId) values ('Azdavay','37') 
insert into Ilceler(Ad,SehirId) values ('Bozkurt / Kastamonu','37') 
insert into Ilceler(Ad,SehirId) values ('Cide','37') 
insert into Ilceler(Ad,SehirId) values ('�atalzeytin','37') 
insert into Ilceler(Ad,SehirId) values ('Daday','37') 
insert into Ilceler(Ad,SehirId) values ('Devrekani','37') 
insert into Ilceler(Ad,SehirId) values ('�nebolu','37') 
insert into Ilceler(Ad,SehirId) values ('Kastamonu Merkez','37') 
insert into Ilceler(Ad,SehirId) values ('K�re','37') 
insert into Ilceler(Ad,SehirId) values ('Ta�k�pr�','37') 
insert into Ilceler(Ad,SehirId) values ('Tosya','37') 
insert into Ilceler(Ad,SehirId) values ('�hsangazi','37') 
insert into Ilceler(Ad,SehirId) values ('P�narba�� / Kastamonu','37') 
insert into Ilceler(Ad,SehirId) values ('�enpazar','37') 
insert into Ilceler(Ad,SehirId) values ('A�l�','37') 
insert into Ilceler(Ad,SehirId) values ('Do�anyurt','37') 
insert into Ilceler(Ad,SehirId) values ('Han�n�','37') 
insert into Ilceler(Ad,SehirId) values ('Seydiler','37') 
insert into Ilceler(Ad,SehirId) values ('B�nyan','38') 
insert into Ilceler(Ad,SehirId) values ('Develi','38') 
insert into Ilceler(Ad,SehirId) values ('Felahiye','38') 
insert into Ilceler(Ad,SehirId) values ('�ncesu','38') 
insert into Ilceler(Ad,SehirId) values ('P�narba�� / Kayseri','38') 
insert into Ilceler(Ad,SehirId) values ('Sar�o�lan','38') 
insert into Ilceler(Ad,SehirId) values ('Sar�z','38') 
insert into Ilceler(Ad,SehirId) values ('Tomarza','38') 
insert into Ilceler(Ad,SehirId) values ('Yahyal�','38') 
insert into Ilceler(Ad,SehirId) values ('Ye�ilhisar','38') 
insert into Ilceler(Ad,SehirId) values ('Akk��la','38') 
insert into Ilceler(Ad,SehirId) values ('Talas','38') 
insert into Ilceler(Ad,SehirId) values ('Kocasinan','38') 
insert into Ilceler(Ad,SehirId) values ('Melikgazi','38') 
insert into Ilceler(Ad,SehirId) values ('Hac�lar','38') 
insert into Ilceler(Ad,SehirId) values ('�zvatan','38') 
insert into Ilceler(Ad,SehirId) values ('Babaeski','39') 
insert into Ilceler(Ad,SehirId) values ('Demirk�y','39') 
insert into Ilceler(Ad,SehirId) values ('K�rklareli Merkez','39') 
insert into Ilceler(Ad,SehirId) values ('Kof�az','39') 
insert into Ilceler(Ad,SehirId) values ('L�leburgaz','39') 
insert into Ilceler(Ad,SehirId) values ('Pehlivank�y','39') 
insert into Ilceler(Ad,SehirId) values ('P�narhisar','39') 
insert into Ilceler(Ad,SehirId) values ('Vize','39') 
insert into Ilceler(Ad,SehirId) values ('�i�ekda��','40') 
insert into Ilceler(Ad,SehirId) values ('Kaman','40') 
insert into Ilceler(Ad,SehirId) values ('K�r�ehir Merkez','40') 
insert into Ilceler(Ad,SehirId) values ('Mucur','40') 
insert into Ilceler(Ad,SehirId) values ('Akp�nar','40') 
insert into Ilceler(Ad,SehirId) values ('Ak�akent','40') 
insert into Ilceler(Ad,SehirId) values ('Boztepe','40') 
insert into Ilceler(Ad,SehirId) values ('Gebze','41') 
insert into Ilceler(Ad,SehirId) values ('G�lc�k','41') 
insert into Ilceler(Ad,SehirId) values ('Kand�ra','41') 
insert into Ilceler(Ad,SehirId) values ('Karam�rsel','41') 
insert into Ilceler(Ad,SehirId) values ('K�rfez','41') 
insert into Ilceler(Ad,SehirId) values ('Derince','41') 
insert into Ilceler(Ad,SehirId) values ('Ba�iskele','41') 
insert into Ilceler(Ad,SehirId) values ('�ay�rova','41') 
insert into Ilceler(Ad,SehirId) values ('Dar�ca','41') 
insert into Ilceler(Ad,SehirId) values ('Dilovas�','41') 
insert into Ilceler(Ad,SehirId) values ('�zmit','41') 
insert into Ilceler(Ad,SehirId) values ('Kartepe','41') 
insert into Ilceler(Ad,SehirId) values ('Ak�ehir','42') 
insert into Ilceler(Ad,SehirId) values ('Bey�ehir','42') 
insert into Ilceler(Ad,SehirId) values ('Bozk�r','42') 
insert into Ilceler(Ad,SehirId) values ('Cihanbeyli','42') 
insert into Ilceler(Ad,SehirId) values ('�umra','42') 
insert into Ilceler(Ad,SehirId) values ('Do�anhisar','42') 
insert into Ilceler(Ad,SehirId) values ('Ere�li / Konya','42') 
insert into Ilceler(Ad,SehirId) values ('Hadim','42') 
insert into Ilceler(Ad,SehirId) values ('Ilg�n','42') 
insert into Ilceler(Ad,SehirId) values ('Kad�nhan�','42') 
insert into Ilceler(Ad,SehirId) values ('Karap�nar','42') 
insert into Ilceler(Ad,SehirId) values ('Kulu','42') 
insert into Ilceler(Ad,SehirId) values ('Saray�n�','42') 
insert into Ilceler(Ad,SehirId) values ('Seydi�ehir','42') 
insert into Ilceler(Ad,SehirId) values ('Yunak','42') 
insert into Ilceler(Ad,SehirId) values ('Ak�ren','42') 
insert into Ilceler(Ad,SehirId) values ('Alt�nekin','42') 
insert into Ilceler(Ad,SehirId) values ('Derebucak','42') 
insert into Ilceler(Ad,SehirId) values ('H�y�k','42') 
insert into Ilceler(Ad,SehirId) values ('Karatay','42') 
insert into Ilceler(Ad,SehirId) values ('Meram','42') 
insert into Ilceler(Ad,SehirId) values ('Sel�uklu','42') 
insert into Ilceler(Ad,SehirId) values ('Ta�kent','42') 
insert into Ilceler(Ad,SehirId) values ('Ah�rl�','42') 
insert into Ilceler(Ad,SehirId) values ('�eltik','42') 
insert into Ilceler(Ad,SehirId) values ('Derbent','42') 
insert into Ilceler(Ad,SehirId) values ('Emirgazi','42') 
insert into Ilceler(Ad,SehirId) values ('G�neys�n�r','42') 
insert into Ilceler(Ad,SehirId) values ('Halkap�nar','42') 
insert into Ilceler(Ad,SehirId) values ('Tuzluk�u','42') 
insert into Ilceler(Ad,SehirId) values ('Yal�h�y�k','42') 
insert into Ilceler(Ad,SehirId) values ('Alt�nta�','43') 
insert into Ilceler(Ad,SehirId) values ('Domani�','43') 
insert into Ilceler(Ad,SehirId) values ('Emet','43') 
insert into Ilceler(Ad,SehirId) values ('Gediz','43') 
insert into Ilceler(Ad,SehirId) values ('K�tahya Merkez','43') 
insert into Ilceler(Ad,SehirId) values ('Simav','43') 
insert into Ilceler(Ad,SehirId) values ('Tav�anl�','43') 
insert into Ilceler(Ad,SehirId) values ('Aslanapa','43') 
insert into Ilceler(Ad,SehirId) values ('Dumlup�nar','43') 
insert into Ilceler(Ad,SehirId) values ('Hisarc�k','43') 
insert into Ilceler(Ad,SehirId) values ('�aphane','43') 
insert into Ilceler(Ad,SehirId) values ('�avdarhisar','43') 
insert into Ilceler(Ad,SehirId) values ('Pazarlar','43') 
insert into Ilceler(Ad,SehirId) values ('Ak�ada�','44') 
insert into Ilceler(Ad,SehirId) values ('Arapgir','44') 
insert into Ilceler(Ad,SehirId) values ('Arguvan','44') 
insert into Ilceler(Ad,SehirId) values ('Darende','44') 
insert into Ilceler(Ad,SehirId) values ('Do�an�ehir','44') 
insert into Ilceler(Ad,SehirId) values ('Hekimhan','44') 
insert into Ilceler(Ad,SehirId) values ('P�t�rge','44') 
insert into Ilceler(Ad,SehirId) values ('Ye�ilyurt / Malatya','44') 
insert into Ilceler(Ad,SehirId) values ('Battalgazi','44') 
insert into Ilceler(Ad,SehirId) values ('Do�anyol','44') 
insert into Ilceler(Ad,SehirId) values ('Kale / Malatya','44') 
insert into Ilceler(Ad,SehirId) values ('Kuluncak','44') 
insert into Ilceler(Ad,SehirId) values ('Yaz�han','44') 
insert into Ilceler(Ad,SehirId) values ('Akhisar','45') 
insert into Ilceler(Ad,SehirId) values ('Ala�ehir','45') 
insert into Ilceler(Ad,SehirId) values ('Demirci','45') 
insert into Ilceler(Ad,SehirId) values ('G�rdes','45') 
insert into Ilceler(Ad,SehirId) values ('K�rka�a�','45') 
insert into Ilceler(Ad,SehirId) values ('Kula','45') 
insert into Ilceler(Ad,SehirId) values ('Salihli','45') 
insert into Ilceler(Ad,SehirId) values ('Sar�g�l','45') 
insert into Ilceler(Ad,SehirId) values ('Saruhanl�','45') 
insert into Ilceler(Ad,SehirId) values ('Selendi','45') 
insert into Ilceler(Ad,SehirId) values ('Soma','45') 
insert into Ilceler(Ad,SehirId) values ('Turgutlu','45') 
insert into Ilceler(Ad,SehirId) values ('Ahmetli','45') 
insert into Ilceler(Ad,SehirId) values ('G�lmarmara','45') 
insert into Ilceler(Ad,SehirId) values ('K�pr�ba�� / Manisa','45') 
insert into Ilceler(Ad,SehirId) values ('�ehzadeler','45') 
insert into Ilceler(Ad,SehirId) values ('Yunusemre','45') 
insert into Ilceler(Ad,SehirId) values ('Af�in','46') 
insert into Ilceler(Ad,SehirId) values ('And�r�n','46') 
insert into Ilceler(Ad,SehirId) values ('Elbistan','46') 
insert into Ilceler(Ad,SehirId) values ('G�ksun','46') 
insert into Ilceler(Ad,SehirId) values ('Pazarc�k','46') 
insert into Ilceler(Ad,SehirId) values ('T�rko�lu','46') 
insert into Ilceler(Ad,SehirId) values ('�a�layancerit','46') 
insert into Ilceler(Ad,SehirId) values ('Ekin�z�','46') 
insert into Ilceler(Ad,SehirId) values ('Nurhak','46') 
insert into Ilceler(Ad,SehirId) values ('Dulkadiro�lu','46') 
insert into Ilceler(Ad,SehirId) values ('Oniki�ubat','46') 
insert into Ilceler(Ad,SehirId) values ('Derik','47') 
insert into Ilceler(Ad,SehirId) values ('K�z�ltepe','47') 
insert into Ilceler(Ad,SehirId) values ('Maz�da��','47') 
insert into Ilceler(Ad,SehirId) values ('Midyat','47') 
insert into Ilceler(Ad,SehirId) values ('Nusaybin','47') 
insert into Ilceler(Ad,SehirId) values ('�merli','47') 
insert into Ilceler(Ad,SehirId) values ('Savur','47') 
insert into Ilceler(Ad,SehirId) values ('Darge�it','47') 
insert into Ilceler(Ad,SehirId) values ('Ye�illi','47') 
insert into Ilceler(Ad,SehirId) values ('Artuklu','47') 
insert into Ilceler(Ad,SehirId) values ('Bodrum','48') 
insert into Ilceler(Ad,SehirId) values ('Dat�a','48') 
insert into Ilceler(Ad,SehirId) values ('Fethiye','48') 
insert into Ilceler(Ad,SehirId) values ('K�yce�iz','48') 
insert into Ilceler(Ad,SehirId) values ('Marmaris','48') 
insert into Ilceler(Ad,SehirId) values ('Milas','48') 
insert into Ilceler(Ad,SehirId) values ('Ula','48') 
insert into Ilceler(Ad,SehirId) values ('Yata�an','48') 
insert into Ilceler(Ad,SehirId) values ('Dalaman','48') 
insert into Ilceler(Ad,SehirId) values ('Ortaca','48') 
insert into Ilceler(Ad,SehirId) values ('Kavakl�dere','48') 
insert into Ilceler(Ad,SehirId) values ('Mente�e','48') 
insert into Ilceler(Ad,SehirId) values ('Seydikemer','48') 
insert into Ilceler(Ad,SehirId) values ('Bulan�k','49') 
insert into Ilceler(Ad,SehirId) values ('Malazgirt','49') 
insert into Ilceler(Ad,SehirId) values ('Mu� Merkez','49') 
insert into Ilceler(Ad,SehirId) values ('Varto','49') 
insert into Ilceler(Ad,SehirId) values ('Hask�y','49') 
insert into Ilceler(Ad,SehirId) values ('Korkut','49') 
insert into Ilceler(Ad,SehirId) values ('Avanos','50') 
insert into Ilceler(Ad,SehirId) values ('Derinkuyu','50') 
insert into Ilceler(Ad,SehirId) values ('G�l�ehir','50') 
insert into Ilceler(Ad,SehirId) values ('Hac�bekta�','50') 
insert into Ilceler(Ad,SehirId) values ('Kozakl�','50') 
insert into Ilceler(Ad,SehirId) values ('Nev�ehir Merkez','50') 
insert into Ilceler(Ad,SehirId) values ('�rg�p','50') 
insert into Ilceler(Ad,SehirId) values ('Ac�g�l','50') 
insert into Ilceler(Ad,SehirId) values ('Bor','51') 
insert into Ilceler(Ad,SehirId) values ('�amard�','51') 
insert into Ilceler(Ad,SehirId) values ('Ni�de Merkez','51') 
insert into Ilceler(Ad,SehirId) values ('Uluk��la','51') 
insert into Ilceler(Ad,SehirId) values ('Altunhisar','51') 
insert into Ilceler(Ad,SehirId) values ('�iftlik','51') 
insert into Ilceler(Ad,SehirId) values ('Akku�','52') 
insert into Ilceler(Ad,SehirId) values ('Aybast�','52') 
insert into Ilceler(Ad,SehirId) values ('Fatsa','52') 
insert into Ilceler(Ad,SehirId) values ('G�lk�y','52') 
insert into Ilceler(Ad,SehirId) values ('Korgan','52') 
insert into Ilceler(Ad,SehirId) values ('Kumru','52') 
insert into Ilceler(Ad,SehirId) values ('Mesudiye','52') 
insert into Ilceler(Ad,SehirId) values ('Per�embe','52') 
insert into Ilceler(Ad,SehirId) values ('Ulubey / Ordu','52') 
insert into Ilceler(Ad,SehirId) values ('�nye','52') 
insert into Ilceler(Ad,SehirId) values ('G�lyal�','52') 
insert into Ilceler(Ad,SehirId) values ('G�rgentepe','52') 
insert into Ilceler(Ad,SehirId) values ('�ama�','52') 
insert into Ilceler(Ad,SehirId) values ('�atalp�nar','52') 
insert into Ilceler(Ad,SehirId) values ('�ayba��','52') 
insert into Ilceler(Ad,SehirId) values ('�kizce','52') 
insert into Ilceler(Ad,SehirId) values ('Kabad�z','52') 
insert into Ilceler(Ad,SehirId) values ('Kabata�','52') 
insert into Ilceler(Ad,SehirId) values ('Alt�nordu','52') 
insert into Ilceler(Ad,SehirId) values ('Arde�en','53') 
insert into Ilceler(Ad,SehirId) values ('�aml�hem�in','53') 
insert into Ilceler(Ad,SehirId) values ('�ayeli','53') 
insert into Ilceler(Ad,SehirId) values ('F�nd�kl�','53') 
insert into Ilceler(Ad,SehirId) values ('�kizdere','53') 
insert into Ilceler(Ad,SehirId) values ('Kalkandere','53') 
insert into Ilceler(Ad,SehirId) values ('Pazar / Rize','53') 
insert into Ilceler(Ad,SehirId) values ('Rize Merkez','53') 
insert into Ilceler(Ad,SehirId) values ('G�neysu','53') 
insert into Ilceler(Ad,SehirId) values ('Derepazar�','53') 
insert into Ilceler(Ad,SehirId) values ('Hem�in','53') 
insert into Ilceler(Ad,SehirId) values ('�yidere','53') 
insert into Ilceler(Ad,SehirId) values ('Akyaz�','54') 
insert into Ilceler(Ad,SehirId) values ('Geyve','54') 
insert into Ilceler(Ad,SehirId) values ('Hendek','54') 
insert into Ilceler(Ad,SehirId) values ('Karasu','54') 
insert into Ilceler(Ad,SehirId) values ('Kaynarca','54') 
insert into Ilceler(Ad,SehirId) values ('Sapanca','54') 
insert into Ilceler(Ad,SehirId) values ('Kocaali','54') 
insert into Ilceler(Ad,SehirId) values ('Pamukova','54') 
insert into Ilceler(Ad,SehirId) values ('Tarakl�','54') 
insert into Ilceler(Ad,SehirId) values ('Ferizli','54') 
insert into Ilceler(Ad,SehirId) values ('Karap�r�ek','54') 
insert into Ilceler(Ad,SehirId) values ('S���tl�','54') 
insert into Ilceler(Ad,SehirId) values ('Adapazar�','54') 
insert into Ilceler(Ad,SehirId) values ('Arifiye','54') 
insert into Ilceler(Ad,SehirId) values ('Erenler','54') 
insert into Ilceler(Ad,SehirId) values ('Serdivan','54') 
insert into Ilceler(Ad,SehirId) values ('Ala�am','55') 
insert into Ilceler(Ad,SehirId) values ('Bafra','55') 
insert into Ilceler(Ad,SehirId) values ('�ar�amba','55') 
insert into Ilceler(Ad,SehirId) values ('Havza','55') 
insert into Ilceler(Ad,SehirId) values ('Kavak','55') 
insert into Ilceler(Ad,SehirId) values ('Ladik','55') 
insert into Ilceler(Ad,SehirId) values ('Terme','55') 
insert into Ilceler(Ad,SehirId) values ('Vezirk�pr�','55') 
insert into Ilceler(Ad,SehirId) values ('Asarc�k','55') 
insert into Ilceler(Ad,SehirId) values ('43604','55') 
insert into Ilceler(Ad,SehirId) values ('Sal�pazar�','55') 
insert into Ilceler(Ad,SehirId) values ('Tekkek�y','55') 
insert into Ilceler(Ad,SehirId) values ('Ayvac�k / Samsun','55') 
insert into Ilceler(Ad,SehirId) values ('Yakakent','55') 
insert into Ilceler(Ad,SehirId) values ('Atakum','55') 
insert into Ilceler(Ad,SehirId) values ('Canik','55') 
insert into Ilceler(Ad,SehirId) values ('�lkad�m','55') 
insert into Ilceler(Ad,SehirId) values ('Baykan','56') 
insert into Ilceler(Ad,SehirId) values ('Eruh','56') 
insert into Ilceler(Ad,SehirId) values ('Kurtalan','56') 
insert into Ilceler(Ad,SehirId) values ('Pervari','56') 
insert into Ilceler(Ad,SehirId) values ('Siirt Merkez','56') 
insert into Ilceler(Ad,SehirId) values ('�irvan','56') 
insert into Ilceler(Ad,SehirId) values ('Tillo','56') 
insert into Ilceler(Ad,SehirId) values ('Ayanc�k','57') 
insert into Ilceler(Ad,SehirId) values ('Boyabat','57') 
insert into Ilceler(Ad,SehirId) values ('Dura�an','57') 
insert into Ilceler(Ad,SehirId) values ('Erfelek','57') 
insert into Ilceler(Ad,SehirId) values ('Gerze','57') 
insert into Ilceler(Ad,SehirId) values ('Sinop Merkez','57') 
insert into Ilceler(Ad,SehirId) values ('T�rkeli','57') 
insert into Ilceler(Ad,SehirId) values ('Dikmen','57') 
insert into Ilceler(Ad,SehirId) values ('Sarayd�z�','57') 
insert into Ilceler(Ad,SehirId) values ('Divri�i','58') 
insert into Ilceler(Ad,SehirId) values ('Gemerek','58') 
insert into Ilceler(Ad,SehirId) values ('G�r�n','58') 
insert into Ilceler(Ad,SehirId) values ('Hafik','58') 
insert into Ilceler(Ad,SehirId) values ('�mranl�','58') 
insert into Ilceler(Ad,SehirId) values ('Kangal','58') 
insert into Ilceler(Ad,SehirId) values ('Koyulhisar','58') 
insert into Ilceler(Ad,SehirId) values ('Sivas Merkez','58') 
insert into Ilceler(Ad,SehirId) values ('Su�ehri','58') 
insert into Ilceler(Ad,SehirId) values ('�ark��la','58') 
insert into Ilceler(Ad,SehirId) values ('Y�ld�zeli','58') 
insert into Ilceler(Ad,SehirId) values ('Zara','58') 
insert into Ilceler(Ad,SehirId) values ('Ak�nc�lar','58') 
insert into Ilceler(Ad,SehirId) values ('Alt�nyayla / Sivas','58') 
insert into Ilceler(Ad,SehirId) values ('Do�an�ar','58') 
insert into Ilceler(Ad,SehirId) values ('G�lova','58') 
insert into Ilceler(Ad,SehirId) values ('Ula�','58') 
insert into Ilceler(Ad,SehirId) values ('�erkezk�y','59') 
insert into Ilceler(Ad,SehirId) values ('�orlu','59') 
insert into Ilceler(Ad,SehirId) values ('Hayrabolu','59') 
insert into Ilceler(Ad,SehirId) values ('Malkara','59') 
insert into Ilceler(Ad,SehirId) values ('Muratl�','59') 
insert into Ilceler(Ad,SehirId) values ('Saray / Tekirda�','59') 
insert into Ilceler(Ad,SehirId) values ('�ark�y','59') 
insert into Ilceler(Ad,SehirId) values ('Marmaraere�lisi','59') 
insert into Ilceler(Ad,SehirId) values ('Ergene','59') 
insert into Ilceler(Ad,SehirId) values ('Kapakl�','59') 
insert into Ilceler(Ad,SehirId) values ('S�leymanpa�a','59') 
insert into Ilceler(Ad,SehirId) values ('Almus','60') 
insert into Ilceler(Ad,SehirId) values ('Artova','60') 
insert into Ilceler(Ad,SehirId) values ('Erbaa','60') 
insert into Ilceler(Ad,SehirId) values ('Niksar','60') 
insert into Ilceler(Ad,SehirId) values ('Re�adiye','60') 
insert into Ilceler(Ad,SehirId) values ('Tokat Merkez','60') 
insert into Ilceler(Ad,SehirId) values ('Turhal','60') 
insert into Ilceler(Ad,SehirId) values ('Zile','60') 
insert into Ilceler(Ad,SehirId) values ('Pazar / Tokat','60') 
insert into Ilceler(Ad,SehirId) values ('Ye�ilyurt / Tokat','60') 
insert into Ilceler(Ad,SehirId) values ('Ba��iftlik','60') 
insert into Ilceler(Ad,SehirId) values ('Sulusaray','60') 
insert into Ilceler(Ad,SehirId) values ('Ak�aabat','61') 
insert into Ilceler(Ad,SehirId) values ('Arakl�','61') 
insert into Ilceler(Ad,SehirId) values ('Arsin','61') 
insert into Ilceler(Ad,SehirId) values ('�aykara','61') 
insert into Ilceler(Ad,SehirId) values ('Ma�ka','61') 
insert into Ilceler(Ad,SehirId) values ('Of','61') 
insert into Ilceler(Ad,SehirId) values ('S�rmene','61') 
insert into Ilceler(Ad,SehirId) values ('Tonya','61') 
insert into Ilceler(Ad,SehirId) values ('Vakf�kebir','61') 
insert into Ilceler(Ad,SehirId) values ('Yomra','61') 
insert into Ilceler(Ad,SehirId) values ('Be�ikd�z�','61') 
insert into Ilceler(Ad,SehirId) values ('�alpazar�','61') 
insert into Ilceler(Ad,SehirId) values ('�ar��ba��','61') 
insert into Ilceler(Ad,SehirId) values ('Dernekpazar�','61') 
insert into Ilceler(Ad,SehirId) values ('D�zk�y','61') 
insert into Ilceler(Ad,SehirId) values ('Hayrat','61') 
insert into Ilceler(Ad,SehirId) values ('K�pr�ba�� / Trabzon','61') 
insert into Ilceler(Ad,SehirId) values ('Ortahisar','61') 
insert into Ilceler(Ad,SehirId) values ('�emi�gezek','62') 
insert into Ilceler(Ad,SehirId) values ('Hozat','62') 
insert into Ilceler(Ad,SehirId) values ('Mazgirt','62') 
insert into Ilceler(Ad,SehirId) values ('Naz�miye','62') 
insert into Ilceler(Ad,SehirId) values ('Ovac�k / Tunceli','62') 
insert into Ilceler(Ad,SehirId) values ('Pertek','62') 
insert into Ilceler(Ad,SehirId) values ('P�l�m�r','62') 
insert into Ilceler(Ad,SehirId) values ('Tunceli Merkez','62') 
insert into Ilceler(Ad,SehirId) values ('Ak�akale','63') 
insert into Ilceler(Ad,SehirId) values ('Birecik','63') 
insert into Ilceler(Ad,SehirId) values ('Bozova','63') 
insert into Ilceler(Ad,SehirId) values ('Ceylanp�nar','63') 
insert into Ilceler(Ad,SehirId) values ('Halfeti','63') 
insert into Ilceler(Ad,SehirId) values ('Hilvan','63') 
insert into Ilceler(Ad,SehirId) values ('Siverek','63') 
insert into Ilceler(Ad,SehirId) values ('Suru�','63') 
insert into Ilceler(Ad,SehirId) values ('Viran�ehir','63') 
insert into Ilceler(Ad,SehirId) values ('Harran','63') 
insert into Ilceler(Ad,SehirId) values ('Eyy�biye','63') 
insert into Ilceler(Ad,SehirId) values ('Haliliye','63') 
insert into Ilceler(Ad,SehirId) values ('Karak�pr�','63') 
insert into Ilceler(Ad,SehirId) values ('Banaz','64') 
insert into Ilceler(Ad,SehirId) values ('E�me','64') 
insert into Ilceler(Ad,SehirId) values ('Karahall�','64') 
insert into Ilceler(Ad,SehirId) values ('Sivasl�','64') 
insert into Ilceler(Ad,SehirId) values ('Ulubey / U�ak','64') 
insert into Ilceler(Ad,SehirId) values ('U�ak Merkez','64') 
insert into Ilceler(Ad,SehirId) values ('Ba�kale','65') 
insert into Ilceler(Ad,SehirId) values ('�atak','65') 
insert into Ilceler(Ad,SehirId) values ('Erci�','65') 
insert into Ilceler(Ad,SehirId) values ('Geva�','65') 
insert into Ilceler(Ad,SehirId) values ('G�rp�nar','65') 
insert into Ilceler(Ad,SehirId) values ('Muradiye','65') 
insert into Ilceler(Ad,SehirId) values ('�zalp','65') 
insert into Ilceler(Ad,SehirId) values ('Bah�esaray','65') 
insert into Ilceler(Ad,SehirId) values ('�ald�ran','65') 
insert into Ilceler(Ad,SehirId) values ('Edremit / Van','65') 
insert into Ilceler(Ad,SehirId) values ('Saray / Van','65') 
insert into Ilceler(Ad,SehirId) values ('�pekyolu','65') 
insert into Ilceler(Ad,SehirId) values ('Tu�ba','65') 
insert into Ilceler(Ad,SehirId) values ('Akda�madeni','66') 
insert into Ilceler(Ad,SehirId) values ('Bo�azl�yan','66') 
insert into Ilceler(Ad,SehirId) values ('�ay�ralan','66') 
insert into Ilceler(Ad,SehirId) values ('�ekerek','66') 
insert into Ilceler(Ad,SehirId) values ('Sar�kaya','66') 
insert into Ilceler(Ad,SehirId) values ('Sorgun','66') 
insert into Ilceler(Ad,SehirId) values ('�efaatli','66') 
insert into Ilceler(Ad,SehirId) values ('Yerk�y','66') 
insert into Ilceler(Ad,SehirId) values ('Yozgat Merkez','66') 
insert into Ilceler(Ad,SehirId) values ('Ayd�nc�k / Yozgat','66') 
insert into Ilceler(Ad,SehirId) values ('�and�r','66') 
insert into Ilceler(Ad,SehirId) values ('Kad��ehri','66') 
insert into Ilceler(Ad,SehirId) values ('Saraykent','66') 
insert into Ilceler(Ad,SehirId) values ('Yenifak�l�','66') 
insert into Ilceler(Ad,SehirId) values ('�aycuma','67') 
insert into Ilceler(Ad,SehirId) values ('Devrek','67') 
insert into Ilceler(Ad,SehirId) values ('Ere�li','67') 
insert into Ilceler(Ad,SehirId) values ('Zonguldak Merkez','67') 
insert into Ilceler(Ad,SehirId) values ('Alapl�','67') 
insert into Ilceler(Ad,SehirId) values ('G�k�ebey','67') 
insert into Ilceler(Ad,SehirId) values ('Kilimli','67') 
insert into Ilceler(Ad,SehirId) values ('Kozlu','67') 
insert into Ilceler(Ad,SehirId) values ('Aksaray Merkez','68') 
insert into Ilceler(Ad,SehirId) values ('Ortak�y / Aksaray','68') 
insert into Ilceler(Ad,SehirId) values ('A�a��ren','68') 
insert into Ilceler(Ad,SehirId) values ('G�zelyurt','68') 
insert into Ilceler(Ad,SehirId) values ('Sar�yah�i','68') 
insert into Ilceler(Ad,SehirId) values ('Eskil','68') 
insert into Ilceler(Ad,SehirId) values ('G�la�a�','68') 
insert into Ilceler(Ad,SehirId) values ('Bayburt Merkez','69') 
insert into Ilceler(Ad,SehirId) values ('Ayd�ntepe','69') 
insert into Ilceler(Ad,SehirId) values ('Demir�z�','69') 
insert into Ilceler(Ad,SehirId) values ('Ermenek','70') 
insert into Ilceler(Ad,SehirId) values ('Karaman Merkez','70') 
insert into Ilceler(Ad,SehirId) values ('Ayranc�','70') 
insert into Ilceler(Ad,SehirId) values ('Kaz�mkarabekir','70') 
insert into Ilceler(Ad,SehirId) values ('Ba�yayla','70') 
insert into Ilceler(Ad,SehirId) values ('Sar�veliler','70') 
insert into Ilceler(Ad,SehirId) values ('Delice','71') 
insert into Ilceler(Ad,SehirId) values ('Keskin','71') 
insert into Ilceler(Ad,SehirId) values ('K�r�kkale Merkez','71') 
insert into Ilceler(Ad,SehirId) values ('Sulakyurt','71') 
insert into Ilceler(Ad,SehirId) values ('Bah�ili','71') 
insert into Ilceler(Ad,SehirId) values ('Bal��eyh','71') 
insert into Ilceler(Ad,SehirId) values ('�elebi','71') 
insert into Ilceler(Ad,SehirId) values ('Karake�ili','71') 
insert into Ilceler(Ad,SehirId) values ('Yah�ihan','71') 
insert into Ilceler(Ad,SehirId) values ('Batman Merkez','72') 
insert into Ilceler(Ad,SehirId) values ('Be�iri','72') 
insert into Ilceler(Ad,SehirId) values ('Gerc��','72') 
insert into Ilceler(Ad,SehirId) values ('Kozluk','72') 
insert into Ilceler(Ad,SehirId) values ('Sason','72') 
insert into Ilceler(Ad,SehirId) values ('Hasankeyf','72') 
insert into Ilceler(Ad,SehirId) values ('Beyt���ebap','73') 
insert into Ilceler(Ad,SehirId) values ('Cizre','73') 
insert into Ilceler(Ad,SehirId) values ('�dil','73') 
insert into Ilceler(Ad,SehirId) values ('Silopi','73') 
insert into Ilceler(Ad,SehirId) values ('��rnak Merkez','73') 
insert into Ilceler(Ad,SehirId) values ('Uludere','73') 
insert into Ilceler(Ad,SehirId) values ('G��l�konak','73') 
insert into Ilceler(Ad,SehirId) values ('Bart�n Merkez','74') 
insert into Ilceler(Ad,SehirId) values ('Kuruca�ile','74') 
insert into Ilceler(Ad,SehirId) values ('Ulus','74') 
insert into Ilceler(Ad,SehirId) values ('Amasra','74') 
insert into Ilceler(Ad,SehirId) values ('Ardahan Merkez','75') 
insert into Ilceler(Ad,SehirId) values ('��ld�r','75') 
insert into Ilceler(Ad,SehirId) values ('G�le','75') 
insert into Ilceler(Ad,SehirId) values ('Hanak','75') 
insert into Ilceler(Ad,SehirId) values ('Posof','75') 
insert into Ilceler(Ad,SehirId) values ('Damal','75') 
insert into Ilceler(Ad,SehirId) values ('Aral�k','76') 
insert into Ilceler(Ad,SehirId) values ('I�d�r Merkez','76') 
insert into Ilceler(Ad,SehirId) values ('Tuzluca','76') 
insert into Ilceler(Ad,SehirId) values ('Karakoyunlu','76') 
insert into Ilceler(Ad,SehirId) values ('Yalova Merkez','77') 
insert into Ilceler(Ad,SehirId) values ('Alt�nova','77') 
insert into Ilceler(Ad,SehirId) values ('Armutlu','77') 
insert into Ilceler(Ad,SehirId) values ('��narc�k','77') 
insert into Ilceler(Ad,SehirId) values ('�iftlikk�y','77') 
insert into Ilceler(Ad,SehirId) values ('Termal','77') 
insert into Ilceler(Ad,SehirId) values ('Eflani','78') 
insert into Ilceler(Ad,SehirId) values ('Eskipazar','78') 
insert into Ilceler(Ad,SehirId) values ('Karab�k Merkez','78') 
insert into Ilceler(Ad,SehirId) values ('Ovac�k / Karab�k','78') 
insert into Ilceler(Ad,SehirId) values ('Safranbolu','78') 
insert into Ilceler(Ad,SehirId) values ('Yenice / Karab�k','78') 
insert into Ilceler(Ad,SehirId) values ('Kilis Merkez','79') 
insert into Ilceler(Ad,SehirId) values ('Elbeyli','79') 
insert into Ilceler(Ad,SehirId) values ('Musabeyli','79') 
insert into Ilceler(Ad,SehirId) values ('Polateli','79') 
insert into Ilceler(Ad,SehirId) values ('Bah�e','80') 
insert into Ilceler(Ad,SehirId) values ('Kadirli','80') 
insert into Ilceler(Ad,SehirId) values ('Osmaniye Merkez','80') 
insert into Ilceler(Ad,SehirId) values ('D�zi�i','80') 
insert into Ilceler(Ad,SehirId) values ('Hasanbeyli','80') 
insert into Ilceler(Ad,SehirId) values ('Sumbas','80') 
insert into Ilceler(Ad,SehirId) values ('Toprakkale','80') 
insert into Ilceler(Ad,SehirId) values ('Ak�akoca','81') 
insert into Ilceler(Ad,SehirId) values ('D�zce Merkez','81') 
insert into Ilceler(Ad,SehirId) values ('Y���lca','81') 
insert into Ilceler(Ad,SehirId) values ('Cumayeri','81') 
insert into Ilceler(Ad,SehirId) values ('G�lyaka','81') 
insert into Ilceler(Ad,SehirId) values ('�ilimli','81') 
insert into Ilceler(Ad,SehirId) values ('G�m��ova','81') 
insert into Ilceler(Ad,SehirId) values ('Kayna�l�','81')

insert into KanGruplari(KanGrubu) values('A+')
insert into KanGruplari(KanGrubu) values('A-')
insert into KanGruplari(KanGrubu) values('B+')
insert into KanGruplari(KanGrubu) values('B-')
insert into KanGruplari(KanGrubu) values('AB+')
insert into KanGruplari(KanGrubu) values('AB-')
insert into KanGruplari(KanGrubu) values('0+')
insert into KanGruplari(KanGrubu) values('0-')

insert into Gorevler(Pozisyon) values('Resepsiyon G�revlisi')
insert into Gorevler(Pozisyon) values('Temizlik G�revlisi')
insert into Gorevler(Pozisyon) values('A���')
insert into Gorevler(Pozisyon) values('Garson')
insert into Gorevler(Pozisyon) values('Elektirik�i')
insert into Gorevler(Pozisyon) values('Bilgi ��lem Sorumlusu')
insert into Gorevler(Pozisyon) values('Y�netici')

insert into Maaslar(MaasTanimi,Maas) values ('�ef Garson Saatlik',18)
insert into Maaslar(MaasTanimi,Maas) values ('Garson Saatlik',12)
insert into Maaslar(MaasTanimi,Maas) values ('Master A��� Saatlik',30)
insert into Maaslar(MaasTanimi,Maas) values ('A��� Yama��',12)
insert into Maaslar(MaasTanimi,Maas) values ('Temizlik G�revlisi',13)
insert into Maaslar(MaasTanimi,Maas) values ('Elektirik Teknisyeni',15)
insert into Maaslar(MaasTanimi,Maas) values ('IT Melih Bey',25)
insert into Maaslar(MaasTanimi,Maas) values ('Resepsiyon G�revlisi',12)
insert into Maaslar(MaasTanimi,Maas) values ('�nsan Kaynaklar�',3500)
insert into Maaslar(MaasTanimi,Maas) values ('Sat�� Departman�',4000)
go
create function fn_TarihConvert
(
	@Tarih nvarchar(10)
)
returns date
begin
	declare @gun nvarchar(2)
	declare @ay nvarchar(2)
	declare @y�l nvarchar(4)
	set @gun = SUBSTRING(@Tarih,1,2)
	set @ay=SUBSTRING(@Tarih,4,2)
	set @y�l=SUBSTRING(@Tarih,7,4)
	return @ay+'-'+@gun+'-'+@y�l
end
go
create function fn_TarihSaatConvert
(
	@tarihsaat nvarchar(16)
)
returns datetime
begin

	declare @tarih nvarchar(13)
	set @tarih=dbo.fn_TarihConvert(SUBSTRING(@tarihsaat,1,10))
	declare @saat nvarchar(6)
	set @saat=SUBSTRING(@tarihsaat,11,6)
	return @tarih+@saat

end
go
create proc CalisanEkle
(
	@GorevAd� nvarchar(30),
	@MaasTanimi nvarchar(30),
	@KanGrubu nvarchar(3),
	@TcNo bigint,
	@Ad nvarchar(20),
	@Soyad nvarchar(30),
	@Cinsiyet char(1),
	@DogumTarihi nvarchar(13),
	@GirisTarihi nvarchar(13),
	@Email nvarchar(30)
)
as
begin
	insert into Calisanlar values
	(
		(select Id from Gorevler where Pozisyon=@GorevAd�),
		(select Id from Maaslar where MaasTanimi=@MaasTanimi),
		(select Id from KanGruplari where KanGrubu=@KanGrubu),
		@TcNo,@Ad,@Soyad,@Cinsiyet,dbo.fn_TarihConvert(@DogumTarihi),dbo.fn_TarihConvert(@GirisTarihi),null,@Email
	)
end
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'A+', '46518648315','Mehmet','Tuna','E','11-10-1990','03-12-2020','mehmettn@gmail.com'
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'A-', '48531564123','Ahmet','�ks�z','E','11-01-1993','03-12-2020','ahmetoksuz@gmail.com'
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'A+', '54615648153','Serkan','Bayraktar','E','25-04-1995','03-12-2020','serkanbayraktar@gmail.com' 
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'AB+', '46518648315','Serpil','�elik','K','25-10-1992','03-12-2020','serpilcelik@gmail.com' 
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', '0+', '46518648315','Dilek','G�ll�','K','12-12-1986','03-12-2020','dilekgullu@gmail.com'
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'A+', '46518648315','Sevda','Canpolat','K','01-05-1998','03-12-2020','sevdacanplt@gmail.com' 
go
exec CalisanEkle 'Resepsiyon G�revlisi', 'Resepsiyon G�revlisi', 'A+', '46518648315','Gamze','�al��an','K','17/11/1995','03-12-2020','gamzecalisan@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A+', '85654541554','Nermin','�olak','K','25/05/1987','03-12-2020','nermincolak@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', '0+', '18451864644','Fatih','Y�ld�r�m','E','25/01/1978','03-12-2020','fatihyildirim@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A+', '46545895355','Mert','Atmaca','E','09/11/1991','03-12-2020','mertatmaca@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A-', '56465456564','Mahmut','Mahmuto�lu','E','28/10/1975','03-12-2020','mahmutoglu@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', '0+', '56465456564','G�lseren','Beker','K','02/10/1975','03-12-2020','gulserenbeker@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A-', '56465456564','Mumin','L�kseka�maz','E','26/09/1994','03-12-2020','luksekacmazmumin@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', '0+', '56465456564','G�ls�m','Atl�','K','06/06/1982','03-12-2020','gulsum@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', '0-', '56465456564','Fatih','D�nmez','E','15/07/1992','03-12-2020','fatihdonmez@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'AB+', '56465456564','Sinem','��kr�k��','K','11/10/1990','03-12-2020','mertatmaca@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A-', '56465456564','Emre','Y�ld�r�m','E','05/08/1998','03-12-2020','emreyildirim@gmail.com'
go
exec CalisanEkle 'Temizlik G�revlisi', 'Temizlik G�revlisi', 'A+', '56465456564','Sultan','Akg�n','K','06/07/1975','03-12-2020','sultanakgun@gmail.com'
go
exec CalisanEkle 'Bilgi ��lem Sorumlusu', 'IT Melih Bey', 'A+', '48454654846','Melih','Bekta�','E','05/08/1992','03-12-2020','melihbektas@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A+','27898712314','Erol', 'Ba�tu�', 'E','11-06-1981','03.12.2020', 'erolbastug@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik','A+','75295145635', 'DEN�Z','KURUKAFA','E',	'12 08 1991','03.12.2020',	'denizkurukafa@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik','B+', '22706153422', 'EM�NE', 'PALA',  'K', '10.02.1989', '03.12.2020', 'eminepala@gmail.com'
go 
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB+', '84389486730','YUNUS','KU�KONMAZ', 'E',	'02.01.1991', '03.12.2020', 'yunuskuskonmaz@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', '0+', '45104943976', 'EY�P', 'AKDEM�R', 'E', '11.02.1991','03.12.2020', 	'ey�pakdemir@gmail.com'
go 
exec CalisanEkle 'Garson', 'Garson Saatlik', 'B+',	'12104943976', 'SEVDA', '�ENER', 'K',	'01.07.1990',	'04.12.2020', 'sevdasener@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A-', '24504943976', 'U�UR','NAS', 'E', '19.10.1990',	'05.12.2020', 'ugurnas@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB-',	'69104943976', 'EV�N', '�AKAN', 'K', '08.08.1991', '06.12.2020', 	'evincan@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'B-', '31104943976', 'MURAT', 'TUNA', 'E',	'13.02.1988', '06.12.2020', 'murattuna@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A+',	'42295145635', 'MERYEM', 'TOPAL','K', '10.05.1990', '06.12.2020', 'meryemtopal@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', '0-',	'63295145635', 'BURAK', 'SEKMEN', 'E',	'01.01.1991', '05.12.2020', 'buraksekmen@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB+',	'95295145635',	'TANER', 'KORUN', 'E', '15.11.1989', '6.12.2020', 'tanerkorun@gmail.com'
go
exec CalisanEkle 'Garson',	'Garson Saatlik', 'A+', '15295145635', 'FAT�H', 'SAPAN', 'E', '02.11.1991', '5.12.2020', 'fatihsapan@gmail.com'	
go

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('Her �ey dahil paket indirimi', '0.18', '30', '1')

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('Tam pansiyon paket indirimi', '0.16', '30', '1')

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('90 g�n indirimi', '0.23', '90', '1')

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Sadece Konaklama/Pe�in �deme', 400)

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Oda+KAhvalt�/Pe�in �deme',580)

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Sadece Konaklama/Otelde �deme', 480)

insert into HizmetPAketleri(Ad,Fiyat) 
values ('Oda+Kahvalt�/Otelde �deme', 640)



insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Superior King', 'Oda�ehir manzaras�na sahip, her biri 29 metrekarelik 178 adet Superior Oda y�ksek standartlar� ile konforlu bir deneyim vadediyor.', 8)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Deluxe King Yatakl�', 'Sadeli�i konfor ve teknolojiyle birle�tiren, 29 metrekarelik, tamam� deniz manzaral� 32 adet Deluxe Oda, �stanbul�un e�siz e�lencesinden veya yo�un bir i� temposundan sonra sizi rahat ettirmek i�in tasarlanm��.', 8)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Executive King Yatakl�', 'Adalar ve deniz manzaras�na sahip, 29 metrekarelik 19 adet Executive Oda, konfor ve l�ks�n somut bir �rne�ini sunarken t�m beklentilerinizi kar��l�yor.', 7)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Lounge Eri�imli Executive S�it', 'Muhte�em deniz manzaral�, 60 metrekarelik geni� bir alana kurulu 9 adet Executive S�it, modern tasar�mlar�yla ��k ve ferah bir konaklama deneyimi ya�at�yor.', 9)

insert into OdaImkanlari(Ad)
values ('Klima')
insert into OdaImkanlari(Ad)
values ('D�� Hatl� Telefon')
insert into OdaImkanlari(Ad)
values ('Sa� Kurutma Makinesi')
insert into OdaImkanlari(Ad)
values ('�ama��rhane Hizmeti')
insert into OdaImkanlari(Ad)
values ('�nternet Eri�imi(y�ksek H�zl�)')
insert into OdaImkanlari(Ad)
values ('�t� ve �t� masas�(istek �zerine)')
insert into OdaImkanlari(Ad)
values ('Minibar')
insert into OdaImkanlari(Ad)
values ('�zel banyo-tuvalet')
insert into OdaImkanlari(Ad)
values ('Kasa')
insert into OdaImkanlari(Ad)
values ('TV')
insert into OdaImkanlari(Ad)
values ('Havuz Havlusu')
insert into OdaImkanlari(Ad)
values ('Deniz Manzaras�')
insert into OdaImkanlari(Ad)
values ('Bornoz')
insert into OdaImkanlari(Ad)
values ('Masa')

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Superior King'),1)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Deluxe King Yatakl�'),2)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Executive King Yatakl�'),3)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Lounge Eri�imli Executive S�it'),4)


insert into OdaDetaylari(OdaId,YatakTipi,YatakSayisi)
values ((select Id from Odalar where OdaTipiId='1'), 'King', 1)

insert into OdaDetaylari(OdaId,YatakTipi,YatakSayisi)
values ((select Id from Odalar where OdaTipiId='2'), 'King', 1)

insert into OdaDetaylari(OdaId,YatakTipi,YatakSayisi)
values ((select Id from Odalar where OdaTipiId='3'), 'King', 1)

insert into OdaDetaylari(OdaId,YatakTipi,YatakSayisi)
values ((select Id from Odalar where OdaTipiId='4'), 'King', 1)
go
create proc sp_VardiyaEkle
(
	@CalisanId smallint,
	@BaslamaTarihSaat nvarchar(16),
	@BitisTarihSaat nvarchar(16)
)
as
begin
	insert into Vardiyalar values
	(
		@CalisanId,
		dbo.fn_TarihSaatConvert(@BaslamaTarihSaat),
		dbo.fn_TarihSaatConvert(@BitisTarihSaat)
	)
end
go
exec sp_VardiyaEkle 1,'03/12/2020 08:05','03/12/2020 16:03'
go
exec sp_VardiyaEkle 2,'03/12/2020 15:58','04/12/2020 00:05'
go
exec sp_VardiyaEkle 3,'04/12/2020 00:00','04/12/2020 08:00'
go
exec sp_VardiyaEkle 4,'03/12/2020 08:05','03/12/2020 16:03'
go
exec sp_VardiyaEkle 5,'03/12/2020 15:58','04/12/2020 00:05'
go
exec sp_VardiyaEkle 6,'04/12/2020 00:00','04/12/2020 08:00'

go
insert into VardiyaTipleri(Ad,BaslamaSaati,BitisSaati) values ('Sabah', '08:00', '16:00')
go
insert into VardiyaTipleri(Ad,BaslamaSaati,BitisSaati) values ('Ak�am', '16:00', '00:00')
go
insert into VardiyaTipleri(Ad,BaslamaSaati,BitisSaati) values ('Gece', '00:00', '08:00')

go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(1,1,dbo.fn_TarihConvert('03.12.2020'),dbo.fn_TarihConvert('03.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(2,1,dbo.fn_TarihConvert('03.12.2020'),dbo.fn_TarihConvert('03.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(3,2,dbo.fn_TarihConvert('03.12.2020'),dbo.fn_TarihConvert('03.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(4,2,dbo.fn_TarihConvert('03.12.2020'),dbo.fn_TarihConvert('03.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(5,3,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(6,3,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(7,1,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(2,1,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(3,2,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(4,2,dbo.fn_TarihConvert('04.12.2020'),dbo.fn_TarihConvert('04.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(5,3,dbo.fn_TarihConvert('05.12.2020'),dbo.fn_TarihConvert('05.12.2020'))
go
insert into VardiyaPlanlari(CalisanId,VardiyaTipId,BaslamaTarihi,BitisTarihi) 
values(6,3,dbo.fn_TarihConvert('05.12.2020'),dbo.fn_TarihConvert('05.12.2020'))
select *from VardiyaTipleri







create view CalisanMaaslari
as
select c.Ad+' '+c.Soyad as [Ad Soyad], g.Pozisyon,m.MaasTanimi,m.Maas from Calisanlar as c
join KanGruplari as k on c.KanGrubuId=k.Id
join Maaslar as m on m.Id=c.MaasId
join Gorevler as g on g.Id=c.GorevId





