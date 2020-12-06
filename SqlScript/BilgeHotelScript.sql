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
	CýkýsTarihi date,
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
create table CalýsanAdresler
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
	CýkýsTarih datetime not null,
	RezervasyonTarih datetime default getdate(),
)
go
create table IndirimTanýmlariRezervasyonlar
(
	RezervasyonId int references Rezervasyonlar(Id),
	IndirimTanimId smallint references IndirimTanimlari(Id),
	constraint PK_IndirimTanýmlariRezervasyonlar primary key(RezervasyonId,IndirimTanimId)
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
(4, 'Amerika Birleþik Devletleri'),
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
(15, 'Bangladeþ'),
(16, 'Barbados'),
(17, 'Batý Sahra'),
(18, 'Belarus'),
(19, 'Belçika'),
(20, 'Belize'),
(21, 'Benin'),
(22, 'Bhutan'),
(23, 'Birleþik Arap Emirlikleri'),
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
(34, 'Çad'),
(35, 'Çek Cumhuriyeti'),
(36, 'Çin Halk Cumhuriyeti'),
(37, 'Daðlýk Karabað Cumhuriyeti'),
(38, 'Danimarka'),
(39, 'Doðu Timor'),
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
(52, 'Fildiþi Sahilleri'),
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
(65, 'Güney Afrika Cumhuriyeti'),
(66, 'Güney Kore'),
(67, 'Güney Osetya'),
(68, 'Gürcistan'),
(69, 'Haiti'),
(70, 'Hýrvatistan'),
(71, 'Hindistan'),
(72, 'Hollanda'),
(73, 'Honduras'),
(74, 'Irak'),
(75, 'Ýngiltere'),
(76, 'Ýran'),
(77, 'Ýrlanda'),
(78, 'Ýspanya'),
(79, 'Ýsrail'),
(80, 'Ýsveç'),
(81, 'Ýsviçre'),
(82, 'Ýtalya'),
(83, 'Ýzlanda'),
(84, 'Jamaika'),
(85, 'Japonya'),
(86, 'Kamboçya'),
(87, 'Kamerun'),
(88, 'Kanada'),
(89, 'Karadað'),
(90, 'Katar'),
(91, 'Kazakistan'),
(92, 'Kenya'),
(93, 'Kýrgýzistan'),
(94, 'Kýbrýs Cumhuriyeti'),
(95, 'Kiribati'),
(96, 'Kolombiya'),
(97, 'Komorlar'),
(98, 'Kongo'),
(99, 'Kongo Demokratik Cumhuriyeti'),
(100, 'Kosova'),
(101, 'Kosta Rika'),
(102, 'Kuveyt'),
(103, 'Kuzey Kýbrýs Türk Cumhuriyeti'),
(104, 'Kuzey Kore'),
(105, 'Küba'),
(106, 'Lakota Cumhuriyeti'),
(107, 'Laos'),
(108, 'Lesotho'),
(109, 'Letonya'),
(110, 'Liberya'),
(111, 'Libya'),
(112, 'Liechtenstein'),
(113, 'Litvanya'),
(114, 'Lübnan'),
(115, 'Lüksemburg'),
(116, 'Macaristan'),
(117, 'Madagaskar'),
(118, 'Makedonya Cumhuriyeti'),
(119, 'Malavi'),
(120, 'Maldivler'),
(121, 'Malezya'),
(122, 'Mali'),
(123, 'Malta'),
(124, 'Marshall Adalarý'),
(125, 'Meksika'),
(126, 'Mýsýr'),
(127, 'Mikronezya'),
(128, 'Moðolistan'),
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
(141, 'Norveç'),
(142, 'Orta Afrika Cumhuriyeti'),
(143, 'Özbekistan'),
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
(163, 'Seyþeller'),
(164, 'Sýrbistan'),
(165, 'Sierra Leone'),
(166, 'Singapur'),
(167, 'Slovakya'),
(168, 'Slovenya'),
(169, 'Solomon Adalarý'),
(170, 'Somali'),
(171, 'Somaliland'),
(172, 'Sri Lanka'),
(173, 'Sudan'),
(174, 'Surinam'),
(175, 'Suudi Arabistan'),
(176, 'Suriye'),
(177, 'Svaziland'),
(178, 'Þili'),
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
(190, 'Türkiye'),
(191, 'Türkmenistan'),
(192, 'Uganda'),
(193, 'Ukrayna'),
(194, 'Umman'),
(195, 'Uruguay'),
(196, 'Ürdün'),
(197, 'Vanuatu'),
(198, 'Vatikan'),
(199, 'Venezuela'),
(200, 'Vietnam'),
(201, 'Yemen'),
(202, 'Yeni Zelanda'),
(203, 'Yeþil Burun'),
(204, 'Yunanistan'),
(205, 'Zambiya'),
(206, 'Zimbabve');
go
set identity_insert dbo.Ulkeler off
go
insert into Sehirler(Ad,UlkeId) values ('Adana',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Adýyaman',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Afyonkarahisar',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Aðrý',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Amasya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ankara',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Antalya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Artvin',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Aydýn',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Balýkesir',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bilecik',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bingöl',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bitlis',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bolu',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Burdur',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bursa',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Çanakkale',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Çankýrý',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Çorum',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Denizli',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Diyarbakýr',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Edirne',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Elazýð',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Erzincan',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Erzurum',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Eskiþehir',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Gaziantep',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Giresun',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Gümüþhane',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Hakkâri',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Hatay',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Isparta',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mersin',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ýstanbul',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ýzmir',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kars',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kastamonu',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kayseri',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kýrklareli',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kýrþehir',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kocaeli',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Konya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kütahya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Malatya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Manisa',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kahramanmaraþ',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Mardin',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Muðla',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Muþ',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Nevþehir',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Niðde',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ordu',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Rize',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sakarya',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Samsun',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Siirt',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sinop',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Sivas',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tekirdað',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tokat',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Trabzon',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Tunceli',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Þanlýurfa',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Uþak',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Van',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Yozgat',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Zonguldak',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Aksaray',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bayburt',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Karaman',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kýrýkkale',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Batman',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Þýrnak',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Bartýn',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Ardahan',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Iðdýr',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Yalova',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Karabük',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Kilis',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Osmaniye',(select Id from Ulkeler where Ad='Türkiye'))
insert into Sehirler(Ad,UlkeId) values ('Düzce',(select Id from Ulkeler where Ad='Türkiye'))
insert into Ilceler(Ad,SehirId) values ('Seyhan','1') 
insert into Ilceler(Ad,SehirId) values ('Ceyhan','1') 
insert into Ilceler(Ad,SehirId) values ('Feke','1') 
insert into Ilceler(Ad,SehirId) values ('Karaisalý','1') 
insert into Ilceler(Ad,SehirId) values ('Karataþ','1') 
insert into Ilceler(Ad,SehirId) values ('Kozan','1') 
insert into Ilceler(Ad,SehirId) values ('Pozantý','1') 
insert into Ilceler(Ad,SehirId) values ('Saimbeyli','1') 
insert into Ilceler(Ad,SehirId) values ('Tufanbeyli','1') 
insert into Ilceler(Ad,SehirId) values ('Yumurtalýk','1') 
insert into Ilceler(Ad,SehirId) values ('Yüreðir','1') 
insert into Ilceler(Ad,SehirId) values ('Aladað','1') 
insert into Ilceler(Ad,SehirId) values ('Ýmamoðlu','1') 
insert into Ilceler(Ad,SehirId) values ('Sarýçam','1') 
insert into Ilceler(Ad,SehirId) values ('Çukurova','1') 
insert into Ilceler(Ad,SehirId) values ('Adýyaman Merkez','2') 
insert into Ilceler(Ad,SehirId) values ('Besni','2') 
insert into Ilceler(Ad,SehirId) values ('Çelikhan','2') 
insert into Ilceler(Ad,SehirId) values ('Gerger','2') 
insert into Ilceler(Ad,SehirId) values ('Gölbaþý / Adýyaman','2') 
insert into Ilceler(Ad,SehirId) values ('Kahta','2') 
insert into Ilceler(Ad,SehirId) values ('Samsat','2') 
insert into Ilceler(Ad,SehirId) values ('Sincik','2') 
insert into Ilceler(Ad,SehirId) values ('Tut','2') 
insert into Ilceler(Ad,SehirId) values ('Afyonkarahisar Merkez','3') 
insert into Ilceler(Ad,SehirId) values ('Bolvadin','3') 
insert into Ilceler(Ad,SehirId) values ('Çay','3') 
insert into Ilceler(Ad,SehirId) values ('Dazkýrý','3') 
insert into Ilceler(Ad,SehirId) values ('Dinar','3') 
insert into Ilceler(Ad,SehirId) values ('Emirdað','3') 
insert into Ilceler(Ad,SehirId) values ('Ýhsaniye','3') 
insert into Ilceler(Ad,SehirId) values ('Sandýklý','3') 
insert into Ilceler(Ad,SehirId) values ('Sinanpaþa','3') 
insert into Ilceler(Ad,SehirId) values ('Sultandaðý','3') 
insert into Ilceler(Ad,SehirId) values ('Þuhut','3') 
insert into Ilceler(Ad,SehirId) values ('Baþmakçý','3') 
insert into Ilceler(Ad,SehirId) values ('Bayat / Afyonkarahisar','3') 
insert into Ilceler(Ad,SehirId) values ('Ýscehisar','3') 
insert into Ilceler(Ad,SehirId) values ('Çobanlar','3') 
insert into Ilceler(Ad,SehirId) values ('Evciler','3') 
insert into Ilceler(Ad,SehirId) values ('Hocalar','3') 
insert into Ilceler(Ad,SehirId) values ('Kýzýlören','3') 
insert into Ilceler(Ad,SehirId) values ('Aðrý Merkez','4') 
insert into Ilceler(Ad,SehirId) values ('Diyadin','4') 
insert into Ilceler(Ad,SehirId) values ('Doðubayazýt','4') 
insert into Ilceler(Ad,SehirId) values ('Eleþkirt','4') 
insert into Ilceler(Ad,SehirId) values ('Hamur','4') 
insert into Ilceler(Ad,SehirId) values ('Patnos','4') 
insert into Ilceler(Ad,SehirId) values ('Taþlýçay','4') 
insert into Ilceler(Ad,SehirId) values ('Tutak','4') 
insert into Ilceler(Ad,SehirId) values ('Amasya Merkez','5') 
insert into Ilceler(Ad,SehirId) values ('Göynücek','5') 
insert into Ilceler(Ad,SehirId) values ('Gümüþhacýköy','5') 
insert into Ilceler(Ad,SehirId) values ('Merzifon','5') 
insert into Ilceler(Ad,SehirId) values ('Suluova','5') 
insert into Ilceler(Ad,SehirId) values ('Taþova','5') 
insert into Ilceler(Ad,SehirId) values ('Hamamözü','5') 
insert into Ilceler(Ad,SehirId) values ('Altýndað','6') 
insert into Ilceler(Ad,SehirId) values ('Ayaþ','6') 
insert into Ilceler(Ad,SehirId) values ('Bala','6') 
insert into Ilceler(Ad,SehirId) values ('Beypazarý','6') 
insert into Ilceler(Ad,SehirId) values ('Çamlýdere','6') 
insert into Ilceler(Ad,SehirId) values ('Çankaya','6') 
insert into Ilceler(Ad,SehirId) values ('Çubuk','6') 
insert into Ilceler(Ad,SehirId) values ('Elmadað','6') 
insert into Ilceler(Ad,SehirId) values ('Güdül','6') 
insert into Ilceler(Ad,SehirId) values ('Haymana','6') 
insert into Ilceler(Ad,SehirId) values ('Kalecik','6') 
insert into Ilceler(Ad,SehirId) values ('Kýzýlcahamam','6') 
insert into Ilceler(Ad,SehirId) values ('Nallýhan','6') 
insert into Ilceler(Ad,SehirId) values ('Polatlý','6') 
insert into Ilceler(Ad,SehirId) values ('Þereflikoçhisar','6') 
insert into Ilceler(Ad,SehirId) values ('Yenimahalle','6') 
insert into Ilceler(Ad,SehirId) values ('Gölbaþý / Ankara','6') 
insert into Ilceler(Ad,SehirId) values ('Keçiören','6') 
insert into Ilceler(Ad,SehirId) values ('Mamak','6') 
insert into Ilceler(Ad,SehirId) values ('Sincan','6') 
insert into Ilceler(Ad,SehirId) values ('Kazan','6') 
insert into Ilceler(Ad,SehirId) values ('Akyurt','6') 
insert into Ilceler(Ad,SehirId) values ('Etimesgut','6') 
insert into Ilceler(Ad,SehirId) values ('Evren','6') 
insert into Ilceler(Ad,SehirId) values ('Pursaklar','6') 
insert into Ilceler(Ad,SehirId) values ('Akseki','7') 
insert into Ilceler(Ad,SehirId) values ('Alanya','7') 
insert into Ilceler(Ad,SehirId) values ('Elmalý','7') 
insert into Ilceler(Ad,SehirId) values ('Finike','7') 
insert into Ilceler(Ad,SehirId) values ('Gazipaþa','7') 
insert into Ilceler(Ad,SehirId) values ('Gündoðmuþ','7') 
insert into Ilceler(Ad,SehirId) values ('Kaþ','7') 
insert into Ilceler(Ad,SehirId) values ('Korkuteli','7') 
insert into Ilceler(Ad,SehirId) values ('Kumluca','7') 
insert into Ilceler(Ad,SehirId) values ('Manavgat','7') 
insert into Ilceler(Ad,SehirId) values ('Serik','7') 
insert into Ilceler(Ad,SehirId) values ('Demre','7') 
insert into Ilceler(Ad,SehirId) values ('Ýbradý','7') 
insert into Ilceler(Ad,SehirId) values ('Kemer / Antalya','7') 
insert into Ilceler(Ad,SehirId) values ('Aksu / Antalya','7') 
insert into Ilceler(Ad,SehirId) values ('Döþemealtý','7') 
insert into Ilceler(Ad,SehirId) values ('Kepez','7') 
insert into Ilceler(Ad,SehirId) values ('Konyaaltý','7') 
insert into Ilceler(Ad,SehirId) values ('Muratpaþa','7') 
insert into Ilceler(Ad,SehirId) values ('Ardanuç','8') 
insert into Ilceler(Ad,SehirId) values ('Arhavi','8') 
insert into Ilceler(Ad,SehirId) values ('Artvin Merkez','8') 
insert into Ilceler(Ad,SehirId) values ('Borçka','8') 
insert into Ilceler(Ad,SehirId) values ('Hopa','8') 
insert into Ilceler(Ad,SehirId) values ('Þavþat','8') 
insert into Ilceler(Ad,SehirId) values ('Yusufeli','8') 
insert into Ilceler(Ad,SehirId) values ('Murgul','8') 
insert into Ilceler(Ad,SehirId) values ('Bozdoðan','9') 
insert into Ilceler(Ad,SehirId) values ('Çine','9') 
insert into Ilceler(Ad,SehirId) values ('Germencik','9') 
insert into Ilceler(Ad,SehirId) values ('Karacasu','9') 
insert into Ilceler(Ad,SehirId) values ('Koçarlý','9') 
insert into Ilceler(Ad,SehirId) values ('Kuþadasý','9') 
insert into Ilceler(Ad,SehirId) values ('Kuyucak','9') 
insert into Ilceler(Ad,SehirId) values ('Nazilli','9') 
insert into Ilceler(Ad,SehirId) values ('Söke','9') 
insert into Ilceler(Ad,SehirId) values ('Sultanhisar','9') 
insert into Ilceler(Ad,SehirId) values ('Yenipazar / Aydýn','9') 
insert into Ilceler(Ad,SehirId) values ('Buharkent','9') 
insert into Ilceler(Ad,SehirId) values ('Ýncirliova','9') 
insert into Ilceler(Ad,SehirId) values ('Karpuzlu','9') 
insert into Ilceler(Ad,SehirId) values ('Köþk','9') 
insert into Ilceler(Ad,SehirId) values ('Didim','9') 
insert into Ilceler(Ad,SehirId) values ('Efeler','9') 
insert into Ilceler(Ad,SehirId) values ('Ayvalýk','10') 
insert into Ilceler(Ad,SehirId) values ('Balya','10') 
insert into Ilceler(Ad,SehirId) values ('Bandýrma','10') 
insert into Ilceler(Ad,SehirId) values ('Bigadiç','10') 
insert into Ilceler(Ad,SehirId) values ('Burhaniye','10') 
insert into Ilceler(Ad,SehirId) values ('Dursunbey','10') 
insert into Ilceler(Ad,SehirId) values ('Edremit / Balýkesir','10') 
insert into Ilceler(Ad,SehirId) values ('Erdek','10') 
insert into Ilceler(Ad,SehirId) values ('Gönen / Balýkesir','10') 
insert into Ilceler(Ad,SehirId) values ('Havran','10') 
insert into Ilceler(Ad,SehirId) values ('Ývrindi','10') 
insert into Ilceler(Ad,SehirId) values ('Kepsut','10') 
insert into Ilceler(Ad,SehirId) values ('Manyas','10') 
insert into Ilceler(Ad,SehirId) values ('Savaþtepe','10') 
insert into Ilceler(Ad,SehirId) values ('Sýndýrgý','10') 
insert into Ilceler(Ad,SehirId) values ('Susurluk','10') 
insert into Ilceler(Ad,SehirId) values ('Marmara','10') 
insert into Ilceler(Ad,SehirId) values ('Gömeç','10') 
insert into Ilceler(Ad,SehirId) values ('Altýeylül','10') 
insert into Ilceler(Ad,SehirId) values ('Karesi','10') 
insert into Ilceler(Ad,SehirId) values ('Bilecik Merkez','11') 
insert into Ilceler(Ad,SehirId) values ('Bozüyük','11') 
insert into Ilceler(Ad,SehirId) values ('Gölpazarý','11') 
insert into Ilceler(Ad,SehirId) values ('Osmaneli','11') 
insert into Ilceler(Ad,SehirId) values ('Pazaryeri','11') 
insert into Ilceler(Ad,SehirId) values ('Söðüt','11') 
insert into Ilceler(Ad,SehirId) values ('Yenipazar / Bilecik','11') 
insert into Ilceler(Ad,SehirId) values ('Ýnhisar','11') 
insert into Ilceler(Ad,SehirId) values ('Bingöl Merkez','12') 
insert into Ilceler(Ad,SehirId) values ('Genç','12') 
insert into Ilceler(Ad,SehirId) values ('Karlýova','12') 
insert into Ilceler(Ad,SehirId) values ('Kiðý','12') 
insert into Ilceler(Ad,SehirId) values ('Solhan','12') 
insert into Ilceler(Ad,SehirId) values ('Adaklý','12') 
insert into Ilceler(Ad,SehirId) values ('Yayladere','12') 
insert into Ilceler(Ad,SehirId) values ('Yedisu','12') 
insert into Ilceler(Ad,SehirId) values ('Adilcevaz','13') 
insert into Ilceler(Ad,SehirId) values ('Ahlat','13') 
insert into Ilceler(Ad,SehirId) values ('Bitlis Merkez','13') 
insert into Ilceler(Ad,SehirId) values ('Hizan','13') 
insert into Ilceler(Ad,SehirId) values ('Mutki','13') 
insert into Ilceler(Ad,SehirId) values ('Tatvan','13') 
insert into Ilceler(Ad,SehirId) values ('Güroymak','13') 
insert into Ilceler(Ad,SehirId) values ('Bolu Merkez','14') 
insert into Ilceler(Ad,SehirId) values ('Gerede','14') 
insert into Ilceler(Ad,SehirId) values ('Göynük','14') 
insert into Ilceler(Ad,SehirId) values ('Kýbrýscýk','14') 
insert into Ilceler(Ad,SehirId) values ('Mengen','14') 
insert into Ilceler(Ad,SehirId) values ('Mudurnu','14') 
insert into Ilceler(Ad,SehirId) values ('Seben','14') 
insert into Ilceler(Ad,SehirId) values ('Dörtdivan','14') 
insert into Ilceler(Ad,SehirId) values ('Yeniçaða','14') 
insert into Ilceler(Ad,SehirId) values ('Aðlasun','15') 
insert into Ilceler(Ad,SehirId) values ('Bucak','15') 
insert into Ilceler(Ad,SehirId) values ('Burdur Merkez','15') 
insert into Ilceler(Ad,SehirId) values ('Gölhisar','15') 
insert into Ilceler(Ad,SehirId) values ('Tefenni','15') 
insert into Ilceler(Ad,SehirId) values ('Yeþilova','15') 
insert into Ilceler(Ad,SehirId) values ('Karamanlý','15') 
insert into Ilceler(Ad,SehirId) values ('Kemer / Burdur','15') 
insert into Ilceler(Ad,SehirId) values ('Altýnyayla / Burdur','15') 
insert into Ilceler(Ad,SehirId) values ('Çavdýr','15') 
insert into Ilceler(Ad,SehirId) values ('Çeltikçi','15') 
insert into Ilceler(Ad,SehirId) values ('Gemlik','16') 
insert into Ilceler(Ad,SehirId) values ('Ýnegöl','16') 
insert into Ilceler(Ad,SehirId) values ('Ýznik','16') 
insert into Ilceler(Ad,SehirId) values ('Karacabey','16') 
insert into Ilceler(Ad,SehirId) values ('Keles','16') 
insert into Ilceler(Ad,SehirId) values ('Mudanya','16') 
insert into Ilceler(Ad,SehirId) values ('Mustafakemalpaþa','16') 
insert into Ilceler(Ad,SehirId) values ('Orhaneli','16') 
insert into Ilceler(Ad,SehirId) values ('Orhangazi','16') 
insert into Ilceler(Ad,SehirId) values ('Yeniþehir / Bursa','16') 
insert into Ilceler(Ad,SehirId) values ('Büyükorhan','16') 
insert into Ilceler(Ad,SehirId) values ('Harmancýk','16') 
insert into Ilceler(Ad,SehirId) values ('Nilüfer','16') 
insert into Ilceler(Ad,SehirId) values ('Osmangazi','16') 
insert into Ilceler(Ad,SehirId) values ('Yýldýrým','16') 
insert into Ilceler(Ad,SehirId) values ('Gürsu','16') 
insert into Ilceler(Ad,SehirId) values ('Kestel','16') 
insert into Ilceler(Ad,SehirId) values ('Ayvacýk / Çanakkale','17') 
insert into Ilceler(Ad,SehirId) values ('Bayramiç','17') 
insert into Ilceler(Ad,SehirId) values ('Biga','17') 
insert into Ilceler(Ad,SehirId) values ('Bozcaada','17') 
insert into Ilceler(Ad,SehirId) values ('Çan','17') 
insert into Ilceler(Ad,SehirId) values ('Çanakkale Merkez','17') 
insert into Ilceler(Ad,SehirId) values ('Eceabat','17') 
insert into Ilceler(Ad,SehirId) values ('Ezine','17') 
insert into Ilceler(Ad,SehirId) values ('Gelibolu','17') 
insert into Ilceler(Ad,SehirId) values ('Gökçeada','17') 
insert into Ilceler(Ad,SehirId) values ('Lapseki','17') 
insert into Ilceler(Ad,SehirId) values ('Yenice / Çanakkale','17') 
insert into Ilceler(Ad,SehirId) values ('Çankýrý Merkez','18') 
insert into Ilceler(Ad,SehirId) values ('Çerkeþ','18') 
insert into Ilceler(Ad,SehirId) values ('Eldivan','18') 
insert into Ilceler(Ad,SehirId) values ('Ilgaz','18') 
insert into Ilceler(Ad,SehirId) values ('Kurþunlu','18') 
insert into Ilceler(Ad,SehirId) values ('Orta','18') 
insert into Ilceler(Ad,SehirId) values ('Þabanözü','18') 
insert into Ilceler(Ad,SehirId) values ('Yapraklý','18') 
insert into Ilceler(Ad,SehirId) values ('Atkaracalar','18') 
insert into Ilceler(Ad,SehirId) values ('Kýzýlýrmak','18') 
insert into Ilceler(Ad,SehirId) values ('Bayramören','18') 
insert into Ilceler(Ad,SehirId) values ('Korgun','18') 
insert into Ilceler(Ad,SehirId) values ('Alaca','19') 
insert into Ilceler(Ad,SehirId) values ('Bayat / Çorum','19') 
insert into Ilceler(Ad,SehirId) values ('Çorum Merkez','19') 
insert into Ilceler(Ad,SehirId) values ('Ýskilip','19') 
insert into Ilceler(Ad,SehirId) values ('Kargý','19') 
insert into Ilceler(Ad,SehirId) values ('Mecitözü','19') 
insert into Ilceler(Ad,SehirId) values ('Ortaköy / Çorum','19') 
insert into Ilceler(Ad,SehirId) values ('Osmancýk','19') 
insert into Ilceler(Ad,SehirId) values ('Sungurlu','19') 
insert into Ilceler(Ad,SehirId) values ('Boðazkale','19') 
insert into Ilceler(Ad,SehirId) values ('Uðurludað','19') 
insert into Ilceler(Ad,SehirId) values ('Dodurga','19') 
insert into Ilceler(Ad,SehirId) values ('Laçin','19') 
insert into Ilceler(Ad,SehirId) values ('Oðuzlar','19') 
insert into Ilceler(Ad,SehirId) values ('Acýpayam','20') 
insert into Ilceler(Ad,SehirId) values ('Buldan','20') 
insert into Ilceler(Ad,SehirId) values ('Çal','20') 
insert into Ilceler(Ad,SehirId) values ('Çameli','20') 
insert into Ilceler(Ad,SehirId) values ('Çardak','20') 
insert into Ilceler(Ad,SehirId) values ('Çivril','20') 
insert into Ilceler(Ad,SehirId) values ('Güney','20') 
insert into Ilceler(Ad,SehirId) values ('Kale / Denizli','20') 
insert into Ilceler(Ad,SehirId) values ('Sarayköy','20') 
insert into Ilceler(Ad,SehirId) values ('Tavas','20') 
insert into Ilceler(Ad,SehirId) values ('Babadað','20') 
insert into Ilceler(Ad,SehirId) values ('Bekilli','20') 
insert into Ilceler(Ad,SehirId) values ('Honaz','20') 
insert into Ilceler(Ad,SehirId) values ('Serinhisar','20') 
insert into Ilceler(Ad,SehirId) values ('Pamukkale','20') 
insert into Ilceler(Ad,SehirId) values ('Baklan','20') 
insert into Ilceler(Ad,SehirId) values ('Beyaðaç','20') 
insert into Ilceler(Ad,SehirId) values ('Bozkurt / Denizli','20') 
insert into Ilceler(Ad,SehirId) values ('Merkezefendi','20') 
insert into Ilceler(Ad,SehirId) values ('Bismil','21') 
insert into Ilceler(Ad,SehirId) values ('Çermik','21') 
insert into Ilceler(Ad,SehirId) values ('Çýnar','21') 
insert into Ilceler(Ad,SehirId) values ('Çüngüþ','21') 
insert into Ilceler(Ad,SehirId) values ('Dicle','21') 
insert into Ilceler(Ad,SehirId) values ('Ergani','21') 
insert into Ilceler(Ad,SehirId) values ('Hani','21') 
insert into Ilceler(Ad,SehirId) values ('Hazro','21') 
insert into Ilceler(Ad,SehirId) values ('Kulp','21') 
insert into Ilceler(Ad,SehirId) values ('Lice','21') 
insert into Ilceler(Ad,SehirId) values ('Silvan','21') 
insert into Ilceler(Ad,SehirId) values ('Eðil','21') 
insert into Ilceler(Ad,SehirId) values ('Kocaköy','21') 
insert into Ilceler(Ad,SehirId) values ('Baðlar','21') 
insert into Ilceler(Ad,SehirId) values ('Kayapýnar','21') 
insert into Ilceler(Ad,SehirId) values ('Sur','21') 
insert into Ilceler(Ad,SehirId) values ('Yeniþehir / Diyarbakýr','21') 
insert into Ilceler(Ad,SehirId) values ('Edirne Merkez','22') 
insert into Ilceler(Ad,SehirId) values ('Enez','22') 
insert into Ilceler(Ad,SehirId) values ('Havsa','22') 
insert into Ilceler(Ad,SehirId) values ('Ýpsala','22') 
insert into Ilceler(Ad,SehirId) values ('Keþan','22') 
insert into Ilceler(Ad,SehirId) values ('Lalapaþa','22') 
insert into Ilceler(Ad,SehirId) values ('Meriç','22') 
insert into Ilceler(Ad,SehirId) values ('Uzunköprü','22') 
insert into Ilceler(Ad,SehirId) values ('Süloðlu','22') 
insert into Ilceler(Ad,SehirId) values ('Aðýn','23') 
insert into Ilceler(Ad,SehirId) values ('Baskil','23') 
insert into Ilceler(Ad,SehirId) values ('Elazýð Merkez','23') 
insert into Ilceler(Ad,SehirId) values ('Karakoçan','23') 
insert into Ilceler(Ad,SehirId) values ('Keban','23') 
insert into Ilceler(Ad,SehirId) values ('Maden','23') 
insert into Ilceler(Ad,SehirId) values ('Palu','23') 
insert into Ilceler(Ad,SehirId) values ('Sivrice','23') 
insert into Ilceler(Ad,SehirId) values ('Arýcak','23') 
insert into Ilceler(Ad,SehirId) values ('Kovancýlar','23') 
insert into Ilceler(Ad,SehirId) values ('Alacakaya','23') 
insert into Ilceler(Ad,SehirId) values ('Çayýrlý','24') 
insert into Ilceler(Ad,SehirId) values ('Erzincan Merkez','24') 
insert into Ilceler(Ad,SehirId) values ('Ýliç','24') 
insert into Ilceler(Ad,SehirId) values ('Kemah','24') 
insert into Ilceler(Ad,SehirId) values ('Kemaliye','24') 
insert into Ilceler(Ad,SehirId) values ('Refahiye','24') 
insert into Ilceler(Ad,SehirId) values ('Tercan','24') 
insert into Ilceler(Ad,SehirId) values ('Üzümlü','24') 
insert into Ilceler(Ad,SehirId) values ('Otlukbeli','24') 
insert into Ilceler(Ad,SehirId) values ('Aþkale','25') 
insert into Ilceler(Ad,SehirId) values ('Çat','25') 
insert into Ilceler(Ad,SehirId) values ('Hýnýs','25') 
insert into Ilceler(Ad,SehirId) values ('Horasan','25') 
insert into Ilceler(Ad,SehirId) values ('Ýspir','25') 
insert into Ilceler(Ad,SehirId) values ('Karayazý','25') 
insert into Ilceler(Ad,SehirId) values ('Narman','25') 
insert into Ilceler(Ad,SehirId) values ('Oltu','25') 
insert into Ilceler(Ad,SehirId) values ('Olur','25') 
insert into Ilceler(Ad,SehirId) values ('Pasinler','25') 
insert into Ilceler(Ad,SehirId) values ('Þenkaya','25') 
insert into Ilceler(Ad,SehirId) values ('Tekman','25') 
insert into Ilceler(Ad,SehirId) values ('Tortum','25') 
insert into Ilceler(Ad,SehirId) values ('Karaçoban','25') 
insert into Ilceler(Ad,SehirId) values ('Uzundere','25') 
insert into Ilceler(Ad,SehirId) values ('Pazaryolu','25') 
insert into Ilceler(Ad,SehirId) values ('Aziziye','25') 
insert into Ilceler(Ad,SehirId) values ('Köprüköy','25') 
insert into Ilceler(Ad,SehirId) values ('Palandöken','25') 
insert into Ilceler(Ad,SehirId) values ('Yakutiye','25') 
insert into Ilceler(Ad,SehirId) values ('Çifteler','26') 
insert into Ilceler(Ad,SehirId) values ('Mahmudiye','26') 
insert into Ilceler(Ad,SehirId) values ('Mihalýççýk','26') 
insert into Ilceler(Ad,SehirId) values ('Sarýcakaya','26') 
insert into Ilceler(Ad,SehirId) values ('Seyitgazi','26') 
insert into Ilceler(Ad,SehirId) values ('Sivrihisar','26') 
insert into Ilceler(Ad,SehirId) values ('Alpu','26') 
insert into Ilceler(Ad,SehirId) values ('Beylikova','26') 
insert into Ilceler(Ad,SehirId) values ('Ýnönü','26') 
insert into Ilceler(Ad,SehirId) values ('Günyüzü','26') 
insert into Ilceler(Ad,SehirId) values ('Han','26') 
insert into Ilceler(Ad,SehirId) values ('Mihalgazi','26') 
insert into Ilceler(Ad,SehirId) values ('Odunpazarý','26') 
insert into Ilceler(Ad,SehirId) values ('Tepebaþý','26') 
insert into Ilceler(Ad,SehirId) values ('Araban','27') 
insert into Ilceler(Ad,SehirId) values ('Ýslahiye','27') 
insert into Ilceler(Ad,SehirId) values ('Nizip','27') 
insert into Ilceler(Ad,SehirId) values ('Oðuzeli','27') 
insert into Ilceler(Ad,SehirId) values ('Yavuzeli','27') 
insert into Ilceler(Ad,SehirId) values ('Þahinbey','27') 
insert into Ilceler(Ad,SehirId) values ('Þehitkamil','27') 
insert into Ilceler(Ad,SehirId) values ('Karkamýþ','27') 
insert into Ilceler(Ad,SehirId) values ('Nurdaðý','27') 
insert into Ilceler(Ad,SehirId) values ('Alucra','28') 
insert into Ilceler(Ad,SehirId) values ('Bulancak','28') 
insert into Ilceler(Ad,SehirId) values ('Dereli','28') 
insert into Ilceler(Ad,SehirId) values ('Espiye','28') 
insert into Ilceler(Ad,SehirId) values ('Eynesil','28') 
insert into Ilceler(Ad,SehirId) values ('Giresun Merkez','28') 
insert into Ilceler(Ad,SehirId) values ('Görele','28') 
insert into Ilceler(Ad,SehirId) values ('Keþap','28') 
insert into Ilceler(Ad,SehirId) values ('Þebinkarahisar','28') 
insert into Ilceler(Ad,SehirId) values ('Tirebolu','28') 
insert into Ilceler(Ad,SehirId) values ('Piraziz','28') 
insert into Ilceler(Ad,SehirId) values ('Yaðlýdere','28') 
insert into Ilceler(Ad,SehirId) values ('Çamoluk','28') 
insert into Ilceler(Ad,SehirId) values ('Çanakçý','28') 
insert into Ilceler(Ad,SehirId) values ('Doðankent','28') 
insert into Ilceler(Ad,SehirId) values ('Güce','28') 
insert into Ilceler(Ad,SehirId) values ('Gümüþhane Merkez','29') 
insert into Ilceler(Ad,SehirId) values ('Kelkit','29') 
insert into Ilceler(Ad,SehirId) values ('Þiran','29') 
insert into Ilceler(Ad,SehirId) values ('Torul','29') 
insert into Ilceler(Ad,SehirId) values ('Köse','29') 
insert into Ilceler(Ad,SehirId) values ('Kürtün','29') 
insert into Ilceler(Ad,SehirId) values ('Çukurca','30') 
insert into Ilceler(Ad,SehirId) values ('Hakkari Merkez','30') 
insert into Ilceler(Ad,SehirId) values ('Þemdinli','30') 
insert into Ilceler(Ad,SehirId) values ('Yüksekova','30') 
insert into Ilceler(Ad,SehirId) values ('Altýnözü','31') 
insert into Ilceler(Ad,SehirId) values ('Dörtyol','31') 
insert into Ilceler(Ad,SehirId) values ('Hassa','31') 
insert into Ilceler(Ad,SehirId) values ('Ýskenderun','31') 
insert into Ilceler(Ad,SehirId) values ('Kýrýkhan','31') 
insert into Ilceler(Ad,SehirId) values ('Reyhanlý','31') 
insert into Ilceler(Ad,SehirId) values ('Samandað','31') 
insert into Ilceler(Ad,SehirId) values ('Yayladaðý','31') 
insert into Ilceler(Ad,SehirId) values ('Erzin','31') 
insert into Ilceler(Ad,SehirId) values ('Belen','31') 
insert into Ilceler(Ad,SehirId) values ('Kumlu','31') 
insert into Ilceler(Ad,SehirId) values ('Antakya','31') 
insert into Ilceler(Ad,SehirId) values ('Arsuz','31') 
insert into Ilceler(Ad,SehirId) values ('Defne','31') 
insert into Ilceler(Ad,SehirId) values ('Payas','31') 
insert into Ilceler(Ad,SehirId) values ('Atabey','32') 
insert into Ilceler(Ad,SehirId) values ('Eðirdir','32') 
insert into Ilceler(Ad,SehirId) values ('Gelendost','32') 
insert into Ilceler(Ad,SehirId) values ('Isparta Merkez','32') 
insert into Ilceler(Ad,SehirId) values ('Keçiborlu','32') 
insert into Ilceler(Ad,SehirId) values ('Senirkent','32') 
insert into Ilceler(Ad,SehirId) values ('Sütçüler','32') 
insert into Ilceler(Ad,SehirId) values ('Þarkikaraaðaç','32') 
insert into Ilceler(Ad,SehirId) values ('Uluborlu','32') 
insert into Ilceler(Ad,SehirId) values ('Yalvaç','32') 
insert into Ilceler(Ad,SehirId) values ('Aksu / Isparta','32') 
insert into Ilceler(Ad,SehirId) values ('Gönen / Isparta','32') 
insert into Ilceler(Ad,SehirId) values ('Yeniþarbademli','32') 
insert into Ilceler(Ad,SehirId) values ('Anamur','33') 
insert into Ilceler(Ad,SehirId) values ('Erdemli','33') 
insert into Ilceler(Ad,SehirId) values ('Gülnar','33') 
insert into Ilceler(Ad,SehirId) values ('Mut','33') 
insert into Ilceler(Ad,SehirId) values ('Silifke','33') 
insert into Ilceler(Ad,SehirId) values ('Tarsus','33') 
insert into Ilceler(Ad,SehirId) values ('Aydýncýk / Mersin','33') 
insert into Ilceler(Ad,SehirId) values ('Bozyazý','33') 
insert into Ilceler(Ad,SehirId) values ('Çamlýyayla','33') 
insert into Ilceler(Ad,SehirId) values ('Akdeniz','33') 
insert into Ilceler(Ad,SehirId) values ('Mezitli','33') 
insert into Ilceler(Ad,SehirId) values ('Toroslar','33') 
insert into Ilceler(Ad,SehirId) values ('Yeniþehir / Mersin','33') 
insert into Ilceler(Ad,SehirId) values ('Adalar','34') 
insert into Ilceler(Ad,SehirId) values ('Bakýrköy','34') 
insert into Ilceler(Ad,SehirId) values ('Beþiktaþ','34') 
insert into Ilceler(Ad,SehirId) values ('Beykoz','34') 
insert into Ilceler(Ad,SehirId) values ('Beyoðlu','34') 
insert into Ilceler(Ad,SehirId) values ('Çatalca','34') 
insert into Ilceler(Ad,SehirId) values ('Eyüp','34') 
insert into Ilceler(Ad,SehirId) values ('Fatih','34') 
insert into Ilceler(Ad,SehirId) values ('Gaziosmanpaþa','34') 
insert into Ilceler(Ad,SehirId) values ('Kadýköy','34') 
insert into Ilceler(Ad,SehirId) values ('Kartal','34') 
insert into Ilceler(Ad,SehirId) values ('Sarýyer','34') 
insert into Ilceler(Ad,SehirId) values ('Silivri','34') 
insert into Ilceler(Ad,SehirId) values ('Þile','34') 
insert into Ilceler(Ad,SehirId) values ('Þiþli','34') 
insert into Ilceler(Ad,SehirId) values ('Üsküdar','34') 
insert into Ilceler(Ad,SehirId) values ('Zeytinburnu','34') 
insert into Ilceler(Ad,SehirId) values ('Büyükçekmece','34') 
insert into Ilceler(Ad,SehirId) values ('Kaðýthane','34') 
insert into Ilceler(Ad,SehirId) values ('Küçükçekmece','34') 
insert into Ilceler(Ad,SehirId) values ('Pendik','34') 
insert into Ilceler(Ad,SehirId) values ('Ümraniye','34') 
insert into Ilceler(Ad,SehirId) values ('Bayrampaþa','34') 
insert into Ilceler(Ad,SehirId) values ('Avcýlar','34') 
insert into Ilceler(Ad,SehirId) values ('Baðcýlar','34') 
insert into Ilceler(Ad,SehirId) values ('Bahçelievler','34') 
insert into Ilceler(Ad,SehirId) values ('Güngören','34') 
insert into Ilceler(Ad,SehirId) values ('Maltepe','34') 
insert into Ilceler(Ad,SehirId) values ('Sultanbeyli','34') 
insert into Ilceler(Ad,SehirId) values ('Tuzla','34') 
insert into Ilceler(Ad,SehirId) values ('Esenler','34') 
insert into Ilceler(Ad,SehirId) values ('Arnavutköy','34') 
insert into Ilceler(Ad,SehirId) values ('Ataþehir','34') 
insert into Ilceler(Ad,SehirId) values ('Baþakþehir','34') 
insert into Ilceler(Ad,SehirId) values ('Beylikdüzü','34') 
insert into Ilceler(Ad,SehirId) values ('Çekmeköy','34') 
insert into Ilceler(Ad,SehirId) values ('Esenyurt','34') 
insert into Ilceler(Ad,SehirId) values ('Sancaktepe','34') 
insert into Ilceler(Ad,SehirId) values ('Sultangazi','34') 
insert into Ilceler(Ad,SehirId) values ('Aliaða','35') 
insert into Ilceler(Ad,SehirId) values ('Bayýndýr','35') 
insert into Ilceler(Ad,SehirId) values ('Bergama','35') 
insert into Ilceler(Ad,SehirId) values ('Bornova','35') 
insert into Ilceler(Ad,SehirId) values ('Çeþme','35') 
insert into Ilceler(Ad,SehirId) values ('Dikili','35') 
insert into Ilceler(Ad,SehirId) values ('Foça','35') 
insert into Ilceler(Ad,SehirId) values ('Karaburun','35') 
insert into Ilceler(Ad,SehirId) values ('Karþýyaka','35') 
insert into Ilceler(Ad,SehirId) values ('Kemalpaþa / Ýzmir','35') 
insert into Ilceler(Ad,SehirId) values ('Kýnýk','35') 
insert into Ilceler(Ad,SehirId) values ('Kiraz','35') 
insert into Ilceler(Ad,SehirId) values ('Menemen','35') 
insert into Ilceler(Ad,SehirId) values ('Ödemiþ','35') 
insert into Ilceler(Ad,SehirId) values ('Seferihisar','35') 
insert into Ilceler(Ad,SehirId) values ('Selçuk','35') 
insert into Ilceler(Ad,SehirId) values ('Tire','35') 
insert into Ilceler(Ad,SehirId) values ('Torbalý','35') 
insert into Ilceler(Ad,SehirId) values ('Urla','35') 
insert into Ilceler(Ad,SehirId) values ('Beydað','35') 
insert into Ilceler(Ad,SehirId) values ('Buca','35') 
insert into Ilceler(Ad,SehirId) values ('Konak','35') 
insert into Ilceler(Ad,SehirId) values ('Menderes','35') 
insert into Ilceler(Ad,SehirId) values ('Balçova','35') 
insert into Ilceler(Ad,SehirId) values ('Çiðli','35') 
insert into Ilceler(Ad,SehirId) values ('Gaziemir','35') 
insert into Ilceler(Ad,SehirId) values ('Narlýdere','35') 
insert into Ilceler(Ad,SehirId) values ('Güzelbahçe','35') 
insert into Ilceler(Ad,SehirId) values ('Bayraklý','35') 
insert into Ilceler(Ad,SehirId) values ('Karabaðlar','35') 
insert into Ilceler(Ad,SehirId) values ('Arpaçay','36') 
insert into Ilceler(Ad,SehirId) values ('Digor','36') 
insert into Ilceler(Ad,SehirId) values ('Kaðýzman','36') 
insert into Ilceler(Ad,SehirId) values ('Kars Merkez','36') 
insert into Ilceler(Ad,SehirId) values ('Sarýkamýþ','36') 
insert into Ilceler(Ad,SehirId) values ('Selim','36') 
insert into Ilceler(Ad,SehirId) values ('Susuz','36') 
insert into Ilceler(Ad,SehirId) values ('Akyaka','36') 
insert into Ilceler(Ad,SehirId) values ('Abana','37') 
insert into Ilceler(Ad,SehirId) values ('Araç','37') 
insert into Ilceler(Ad,SehirId) values ('Azdavay','37') 
insert into Ilceler(Ad,SehirId) values ('Bozkurt / Kastamonu','37') 
insert into Ilceler(Ad,SehirId) values ('Cide','37') 
insert into Ilceler(Ad,SehirId) values ('Çatalzeytin','37') 
insert into Ilceler(Ad,SehirId) values ('Daday','37') 
insert into Ilceler(Ad,SehirId) values ('Devrekani','37') 
insert into Ilceler(Ad,SehirId) values ('Ýnebolu','37') 
insert into Ilceler(Ad,SehirId) values ('Kastamonu Merkez','37') 
insert into Ilceler(Ad,SehirId) values ('Küre','37') 
insert into Ilceler(Ad,SehirId) values ('Taþköprü','37') 
insert into Ilceler(Ad,SehirId) values ('Tosya','37') 
insert into Ilceler(Ad,SehirId) values ('Ýhsangazi','37') 
insert into Ilceler(Ad,SehirId) values ('Pýnarbaþý / Kastamonu','37') 
insert into Ilceler(Ad,SehirId) values ('Þenpazar','37') 
insert into Ilceler(Ad,SehirId) values ('Aðlý','37') 
insert into Ilceler(Ad,SehirId) values ('Doðanyurt','37') 
insert into Ilceler(Ad,SehirId) values ('Hanönü','37') 
insert into Ilceler(Ad,SehirId) values ('Seydiler','37') 
insert into Ilceler(Ad,SehirId) values ('Bünyan','38') 
insert into Ilceler(Ad,SehirId) values ('Develi','38') 
insert into Ilceler(Ad,SehirId) values ('Felahiye','38') 
insert into Ilceler(Ad,SehirId) values ('Ýncesu','38') 
insert into Ilceler(Ad,SehirId) values ('Pýnarbaþý / Kayseri','38') 
insert into Ilceler(Ad,SehirId) values ('Sarýoðlan','38') 
insert into Ilceler(Ad,SehirId) values ('Sarýz','38') 
insert into Ilceler(Ad,SehirId) values ('Tomarza','38') 
insert into Ilceler(Ad,SehirId) values ('Yahyalý','38') 
insert into Ilceler(Ad,SehirId) values ('Yeþilhisar','38') 
insert into Ilceler(Ad,SehirId) values ('Akkýþla','38') 
insert into Ilceler(Ad,SehirId) values ('Talas','38') 
insert into Ilceler(Ad,SehirId) values ('Kocasinan','38') 
insert into Ilceler(Ad,SehirId) values ('Melikgazi','38') 
insert into Ilceler(Ad,SehirId) values ('Hacýlar','38') 
insert into Ilceler(Ad,SehirId) values ('Özvatan','38') 
insert into Ilceler(Ad,SehirId) values ('Babaeski','39') 
insert into Ilceler(Ad,SehirId) values ('Demirköy','39') 
insert into Ilceler(Ad,SehirId) values ('Kýrklareli Merkez','39') 
insert into Ilceler(Ad,SehirId) values ('Kofçaz','39') 
insert into Ilceler(Ad,SehirId) values ('Lüleburgaz','39') 
insert into Ilceler(Ad,SehirId) values ('Pehlivanköy','39') 
insert into Ilceler(Ad,SehirId) values ('Pýnarhisar','39') 
insert into Ilceler(Ad,SehirId) values ('Vize','39') 
insert into Ilceler(Ad,SehirId) values ('Çiçekdaðý','40') 
insert into Ilceler(Ad,SehirId) values ('Kaman','40') 
insert into Ilceler(Ad,SehirId) values ('Kýrþehir Merkez','40') 
insert into Ilceler(Ad,SehirId) values ('Mucur','40') 
insert into Ilceler(Ad,SehirId) values ('Akpýnar','40') 
insert into Ilceler(Ad,SehirId) values ('Akçakent','40') 
insert into Ilceler(Ad,SehirId) values ('Boztepe','40') 
insert into Ilceler(Ad,SehirId) values ('Gebze','41') 
insert into Ilceler(Ad,SehirId) values ('Gölcük','41') 
insert into Ilceler(Ad,SehirId) values ('Kandýra','41') 
insert into Ilceler(Ad,SehirId) values ('Karamürsel','41') 
insert into Ilceler(Ad,SehirId) values ('Körfez','41') 
insert into Ilceler(Ad,SehirId) values ('Derince','41') 
insert into Ilceler(Ad,SehirId) values ('Baþiskele','41') 
insert into Ilceler(Ad,SehirId) values ('Çayýrova','41') 
insert into Ilceler(Ad,SehirId) values ('Darýca','41') 
insert into Ilceler(Ad,SehirId) values ('Dilovasý','41') 
insert into Ilceler(Ad,SehirId) values ('Ýzmit','41') 
insert into Ilceler(Ad,SehirId) values ('Kartepe','41') 
insert into Ilceler(Ad,SehirId) values ('Akþehir','42') 
insert into Ilceler(Ad,SehirId) values ('Beyþehir','42') 
insert into Ilceler(Ad,SehirId) values ('Bozkýr','42') 
insert into Ilceler(Ad,SehirId) values ('Cihanbeyli','42') 
insert into Ilceler(Ad,SehirId) values ('Çumra','42') 
insert into Ilceler(Ad,SehirId) values ('Doðanhisar','42') 
insert into Ilceler(Ad,SehirId) values ('Ereðli / Konya','42') 
insert into Ilceler(Ad,SehirId) values ('Hadim','42') 
insert into Ilceler(Ad,SehirId) values ('Ilgýn','42') 
insert into Ilceler(Ad,SehirId) values ('Kadýnhaný','42') 
insert into Ilceler(Ad,SehirId) values ('Karapýnar','42') 
insert into Ilceler(Ad,SehirId) values ('Kulu','42') 
insert into Ilceler(Ad,SehirId) values ('Sarayönü','42') 
insert into Ilceler(Ad,SehirId) values ('Seydiþehir','42') 
insert into Ilceler(Ad,SehirId) values ('Yunak','42') 
insert into Ilceler(Ad,SehirId) values ('Akören','42') 
insert into Ilceler(Ad,SehirId) values ('Altýnekin','42') 
insert into Ilceler(Ad,SehirId) values ('Derebucak','42') 
insert into Ilceler(Ad,SehirId) values ('Hüyük','42') 
insert into Ilceler(Ad,SehirId) values ('Karatay','42') 
insert into Ilceler(Ad,SehirId) values ('Meram','42') 
insert into Ilceler(Ad,SehirId) values ('Selçuklu','42') 
insert into Ilceler(Ad,SehirId) values ('Taþkent','42') 
insert into Ilceler(Ad,SehirId) values ('Ahýrlý','42') 
insert into Ilceler(Ad,SehirId) values ('Çeltik','42') 
insert into Ilceler(Ad,SehirId) values ('Derbent','42') 
insert into Ilceler(Ad,SehirId) values ('Emirgazi','42') 
insert into Ilceler(Ad,SehirId) values ('Güneysýnýr','42') 
insert into Ilceler(Ad,SehirId) values ('Halkapýnar','42') 
insert into Ilceler(Ad,SehirId) values ('Tuzlukçu','42') 
insert into Ilceler(Ad,SehirId) values ('Yalýhüyük','42') 
insert into Ilceler(Ad,SehirId) values ('Altýntaþ','43') 
insert into Ilceler(Ad,SehirId) values ('Domaniç','43') 
insert into Ilceler(Ad,SehirId) values ('Emet','43') 
insert into Ilceler(Ad,SehirId) values ('Gediz','43') 
insert into Ilceler(Ad,SehirId) values ('Kütahya Merkez','43') 
insert into Ilceler(Ad,SehirId) values ('Simav','43') 
insert into Ilceler(Ad,SehirId) values ('Tavþanlý','43') 
insert into Ilceler(Ad,SehirId) values ('Aslanapa','43') 
insert into Ilceler(Ad,SehirId) values ('Dumlupýnar','43') 
insert into Ilceler(Ad,SehirId) values ('Hisarcýk','43') 
insert into Ilceler(Ad,SehirId) values ('Þaphane','43') 
insert into Ilceler(Ad,SehirId) values ('Çavdarhisar','43') 
insert into Ilceler(Ad,SehirId) values ('Pazarlar','43') 
insert into Ilceler(Ad,SehirId) values ('Akçadað','44') 
insert into Ilceler(Ad,SehirId) values ('Arapgir','44') 
insert into Ilceler(Ad,SehirId) values ('Arguvan','44') 
insert into Ilceler(Ad,SehirId) values ('Darende','44') 
insert into Ilceler(Ad,SehirId) values ('Doðanþehir','44') 
insert into Ilceler(Ad,SehirId) values ('Hekimhan','44') 
insert into Ilceler(Ad,SehirId) values ('Pütürge','44') 
insert into Ilceler(Ad,SehirId) values ('Yeþilyurt / Malatya','44') 
insert into Ilceler(Ad,SehirId) values ('Battalgazi','44') 
insert into Ilceler(Ad,SehirId) values ('Doðanyol','44') 
insert into Ilceler(Ad,SehirId) values ('Kale / Malatya','44') 
insert into Ilceler(Ad,SehirId) values ('Kuluncak','44') 
insert into Ilceler(Ad,SehirId) values ('Yazýhan','44') 
insert into Ilceler(Ad,SehirId) values ('Akhisar','45') 
insert into Ilceler(Ad,SehirId) values ('Alaþehir','45') 
insert into Ilceler(Ad,SehirId) values ('Demirci','45') 
insert into Ilceler(Ad,SehirId) values ('Gördes','45') 
insert into Ilceler(Ad,SehirId) values ('Kýrkaðaç','45') 
insert into Ilceler(Ad,SehirId) values ('Kula','45') 
insert into Ilceler(Ad,SehirId) values ('Salihli','45') 
insert into Ilceler(Ad,SehirId) values ('Sarýgöl','45') 
insert into Ilceler(Ad,SehirId) values ('Saruhanlý','45') 
insert into Ilceler(Ad,SehirId) values ('Selendi','45') 
insert into Ilceler(Ad,SehirId) values ('Soma','45') 
insert into Ilceler(Ad,SehirId) values ('Turgutlu','45') 
insert into Ilceler(Ad,SehirId) values ('Ahmetli','45') 
insert into Ilceler(Ad,SehirId) values ('Gölmarmara','45') 
insert into Ilceler(Ad,SehirId) values ('Köprübaþý / Manisa','45') 
insert into Ilceler(Ad,SehirId) values ('Þehzadeler','45') 
insert into Ilceler(Ad,SehirId) values ('Yunusemre','45') 
insert into Ilceler(Ad,SehirId) values ('Afþin','46') 
insert into Ilceler(Ad,SehirId) values ('Andýrýn','46') 
insert into Ilceler(Ad,SehirId) values ('Elbistan','46') 
insert into Ilceler(Ad,SehirId) values ('Göksun','46') 
insert into Ilceler(Ad,SehirId) values ('Pazarcýk','46') 
insert into Ilceler(Ad,SehirId) values ('Türkoðlu','46') 
insert into Ilceler(Ad,SehirId) values ('Çaðlayancerit','46') 
insert into Ilceler(Ad,SehirId) values ('Ekinözü','46') 
insert into Ilceler(Ad,SehirId) values ('Nurhak','46') 
insert into Ilceler(Ad,SehirId) values ('Dulkadiroðlu','46') 
insert into Ilceler(Ad,SehirId) values ('Onikiþubat','46') 
insert into Ilceler(Ad,SehirId) values ('Derik','47') 
insert into Ilceler(Ad,SehirId) values ('Kýzýltepe','47') 
insert into Ilceler(Ad,SehirId) values ('Mazýdaðý','47') 
insert into Ilceler(Ad,SehirId) values ('Midyat','47') 
insert into Ilceler(Ad,SehirId) values ('Nusaybin','47') 
insert into Ilceler(Ad,SehirId) values ('Ömerli','47') 
insert into Ilceler(Ad,SehirId) values ('Savur','47') 
insert into Ilceler(Ad,SehirId) values ('Dargeçit','47') 
insert into Ilceler(Ad,SehirId) values ('Yeþilli','47') 
insert into Ilceler(Ad,SehirId) values ('Artuklu','47') 
insert into Ilceler(Ad,SehirId) values ('Bodrum','48') 
insert into Ilceler(Ad,SehirId) values ('Datça','48') 
insert into Ilceler(Ad,SehirId) values ('Fethiye','48') 
insert into Ilceler(Ad,SehirId) values ('Köyceðiz','48') 
insert into Ilceler(Ad,SehirId) values ('Marmaris','48') 
insert into Ilceler(Ad,SehirId) values ('Milas','48') 
insert into Ilceler(Ad,SehirId) values ('Ula','48') 
insert into Ilceler(Ad,SehirId) values ('Yataðan','48') 
insert into Ilceler(Ad,SehirId) values ('Dalaman','48') 
insert into Ilceler(Ad,SehirId) values ('Ortaca','48') 
insert into Ilceler(Ad,SehirId) values ('Kavaklýdere','48') 
insert into Ilceler(Ad,SehirId) values ('Menteþe','48') 
insert into Ilceler(Ad,SehirId) values ('Seydikemer','48') 
insert into Ilceler(Ad,SehirId) values ('Bulanýk','49') 
insert into Ilceler(Ad,SehirId) values ('Malazgirt','49') 
insert into Ilceler(Ad,SehirId) values ('Muþ Merkez','49') 
insert into Ilceler(Ad,SehirId) values ('Varto','49') 
insert into Ilceler(Ad,SehirId) values ('Hasköy','49') 
insert into Ilceler(Ad,SehirId) values ('Korkut','49') 
insert into Ilceler(Ad,SehirId) values ('Avanos','50') 
insert into Ilceler(Ad,SehirId) values ('Derinkuyu','50') 
insert into Ilceler(Ad,SehirId) values ('Gülþehir','50') 
insert into Ilceler(Ad,SehirId) values ('Hacýbektaþ','50') 
insert into Ilceler(Ad,SehirId) values ('Kozaklý','50') 
insert into Ilceler(Ad,SehirId) values ('Nevþehir Merkez','50') 
insert into Ilceler(Ad,SehirId) values ('Ürgüp','50') 
insert into Ilceler(Ad,SehirId) values ('Acýgöl','50') 
insert into Ilceler(Ad,SehirId) values ('Bor','51') 
insert into Ilceler(Ad,SehirId) values ('Çamardý','51') 
insert into Ilceler(Ad,SehirId) values ('Niðde Merkez','51') 
insert into Ilceler(Ad,SehirId) values ('Ulukýþla','51') 
insert into Ilceler(Ad,SehirId) values ('Altunhisar','51') 
insert into Ilceler(Ad,SehirId) values ('Çiftlik','51') 
insert into Ilceler(Ad,SehirId) values ('Akkuþ','52') 
insert into Ilceler(Ad,SehirId) values ('Aybastý','52') 
insert into Ilceler(Ad,SehirId) values ('Fatsa','52') 
insert into Ilceler(Ad,SehirId) values ('Gölköy','52') 
insert into Ilceler(Ad,SehirId) values ('Korgan','52') 
insert into Ilceler(Ad,SehirId) values ('Kumru','52') 
insert into Ilceler(Ad,SehirId) values ('Mesudiye','52') 
insert into Ilceler(Ad,SehirId) values ('Perþembe','52') 
insert into Ilceler(Ad,SehirId) values ('Ulubey / Ordu','52') 
insert into Ilceler(Ad,SehirId) values ('Ünye','52') 
insert into Ilceler(Ad,SehirId) values ('Gülyalý','52') 
insert into Ilceler(Ad,SehirId) values ('Gürgentepe','52') 
insert into Ilceler(Ad,SehirId) values ('Çamaþ','52') 
insert into Ilceler(Ad,SehirId) values ('Çatalpýnar','52') 
insert into Ilceler(Ad,SehirId) values ('Çaybaþý','52') 
insert into Ilceler(Ad,SehirId) values ('Ýkizce','52') 
insert into Ilceler(Ad,SehirId) values ('Kabadüz','52') 
insert into Ilceler(Ad,SehirId) values ('Kabataþ','52') 
insert into Ilceler(Ad,SehirId) values ('Altýnordu','52') 
insert into Ilceler(Ad,SehirId) values ('Ardeþen','53') 
insert into Ilceler(Ad,SehirId) values ('Çamlýhemþin','53') 
insert into Ilceler(Ad,SehirId) values ('Çayeli','53') 
insert into Ilceler(Ad,SehirId) values ('Fýndýklý','53') 
insert into Ilceler(Ad,SehirId) values ('Ýkizdere','53') 
insert into Ilceler(Ad,SehirId) values ('Kalkandere','53') 
insert into Ilceler(Ad,SehirId) values ('Pazar / Rize','53') 
insert into Ilceler(Ad,SehirId) values ('Rize Merkez','53') 
insert into Ilceler(Ad,SehirId) values ('Güneysu','53') 
insert into Ilceler(Ad,SehirId) values ('Derepazarý','53') 
insert into Ilceler(Ad,SehirId) values ('Hemþin','53') 
insert into Ilceler(Ad,SehirId) values ('Ýyidere','53') 
insert into Ilceler(Ad,SehirId) values ('Akyazý','54') 
insert into Ilceler(Ad,SehirId) values ('Geyve','54') 
insert into Ilceler(Ad,SehirId) values ('Hendek','54') 
insert into Ilceler(Ad,SehirId) values ('Karasu','54') 
insert into Ilceler(Ad,SehirId) values ('Kaynarca','54') 
insert into Ilceler(Ad,SehirId) values ('Sapanca','54') 
insert into Ilceler(Ad,SehirId) values ('Kocaali','54') 
insert into Ilceler(Ad,SehirId) values ('Pamukova','54') 
insert into Ilceler(Ad,SehirId) values ('Taraklý','54') 
insert into Ilceler(Ad,SehirId) values ('Ferizli','54') 
insert into Ilceler(Ad,SehirId) values ('Karapürçek','54') 
insert into Ilceler(Ad,SehirId) values ('Söðütlü','54') 
insert into Ilceler(Ad,SehirId) values ('Adapazarý','54') 
insert into Ilceler(Ad,SehirId) values ('Arifiye','54') 
insert into Ilceler(Ad,SehirId) values ('Erenler','54') 
insert into Ilceler(Ad,SehirId) values ('Serdivan','54') 
insert into Ilceler(Ad,SehirId) values ('Alaçam','55') 
insert into Ilceler(Ad,SehirId) values ('Bafra','55') 
insert into Ilceler(Ad,SehirId) values ('Çarþamba','55') 
insert into Ilceler(Ad,SehirId) values ('Havza','55') 
insert into Ilceler(Ad,SehirId) values ('Kavak','55') 
insert into Ilceler(Ad,SehirId) values ('Ladik','55') 
insert into Ilceler(Ad,SehirId) values ('Terme','55') 
insert into Ilceler(Ad,SehirId) values ('Vezirköprü','55') 
insert into Ilceler(Ad,SehirId) values ('Asarcýk','55') 
insert into Ilceler(Ad,SehirId) values ('43604','55') 
insert into Ilceler(Ad,SehirId) values ('Salýpazarý','55') 
insert into Ilceler(Ad,SehirId) values ('Tekkeköy','55') 
insert into Ilceler(Ad,SehirId) values ('Ayvacýk / Samsun','55') 
insert into Ilceler(Ad,SehirId) values ('Yakakent','55') 
insert into Ilceler(Ad,SehirId) values ('Atakum','55') 
insert into Ilceler(Ad,SehirId) values ('Canik','55') 
insert into Ilceler(Ad,SehirId) values ('Ýlkadým','55') 
insert into Ilceler(Ad,SehirId) values ('Baykan','56') 
insert into Ilceler(Ad,SehirId) values ('Eruh','56') 
insert into Ilceler(Ad,SehirId) values ('Kurtalan','56') 
insert into Ilceler(Ad,SehirId) values ('Pervari','56') 
insert into Ilceler(Ad,SehirId) values ('Siirt Merkez','56') 
insert into Ilceler(Ad,SehirId) values ('Þirvan','56') 
insert into Ilceler(Ad,SehirId) values ('Tillo','56') 
insert into Ilceler(Ad,SehirId) values ('Ayancýk','57') 
insert into Ilceler(Ad,SehirId) values ('Boyabat','57') 
insert into Ilceler(Ad,SehirId) values ('Duraðan','57') 
insert into Ilceler(Ad,SehirId) values ('Erfelek','57') 
insert into Ilceler(Ad,SehirId) values ('Gerze','57') 
insert into Ilceler(Ad,SehirId) values ('Sinop Merkez','57') 
insert into Ilceler(Ad,SehirId) values ('Türkeli','57') 
insert into Ilceler(Ad,SehirId) values ('Dikmen','57') 
insert into Ilceler(Ad,SehirId) values ('Saraydüzü','57') 
insert into Ilceler(Ad,SehirId) values ('Divriði','58') 
insert into Ilceler(Ad,SehirId) values ('Gemerek','58') 
insert into Ilceler(Ad,SehirId) values ('Gürün','58') 
insert into Ilceler(Ad,SehirId) values ('Hafik','58') 
insert into Ilceler(Ad,SehirId) values ('Ýmranlý','58') 
insert into Ilceler(Ad,SehirId) values ('Kangal','58') 
insert into Ilceler(Ad,SehirId) values ('Koyulhisar','58') 
insert into Ilceler(Ad,SehirId) values ('Sivas Merkez','58') 
insert into Ilceler(Ad,SehirId) values ('Suþehri','58') 
insert into Ilceler(Ad,SehirId) values ('Þarkýþla','58') 
insert into Ilceler(Ad,SehirId) values ('Yýldýzeli','58') 
insert into Ilceler(Ad,SehirId) values ('Zara','58') 
insert into Ilceler(Ad,SehirId) values ('Akýncýlar','58') 
insert into Ilceler(Ad,SehirId) values ('Altýnyayla / Sivas','58') 
insert into Ilceler(Ad,SehirId) values ('Doðanþar','58') 
insert into Ilceler(Ad,SehirId) values ('Gölova','58') 
insert into Ilceler(Ad,SehirId) values ('Ulaþ','58') 
insert into Ilceler(Ad,SehirId) values ('Çerkezköy','59') 
insert into Ilceler(Ad,SehirId) values ('Çorlu','59') 
insert into Ilceler(Ad,SehirId) values ('Hayrabolu','59') 
insert into Ilceler(Ad,SehirId) values ('Malkara','59') 
insert into Ilceler(Ad,SehirId) values ('Muratlý','59') 
insert into Ilceler(Ad,SehirId) values ('Saray / Tekirdað','59') 
insert into Ilceler(Ad,SehirId) values ('Þarköy','59') 
insert into Ilceler(Ad,SehirId) values ('Marmaraereðlisi','59') 
insert into Ilceler(Ad,SehirId) values ('Ergene','59') 
insert into Ilceler(Ad,SehirId) values ('Kapaklý','59') 
insert into Ilceler(Ad,SehirId) values ('Süleymanpaþa','59') 
insert into Ilceler(Ad,SehirId) values ('Almus','60') 
insert into Ilceler(Ad,SehirId) values ('Artova','60') 
insert into Ilceler(Ad,SehirId) values ('Erbaa','60') 
insert into Ilceler(Ad,SehirId) values ('Niksar','60') 
insert into Ilceler(Ad,SehirId) values ('Reþadiye','60') 
insert into Ilceler(Ad,SehirId) values ('Tokat Merkez','60') 
insert into Ilceler(Ad,SehirId) values ('Turhal','60') 
insert into Ilceler(Ad,SehirId) values ('Zile','60') 
insert into Ilceler(Ad,SehirId) values ('Pazar / Tokat','60') 
insert into Ilceler(Ad,SehirId) values ('Yeþilyurt / Tokat','60') 
insert into Ilceler(Ad,SehirId) values ('Baþçiftlik','60') 
insert into Ilceler(Ad,SehirId) values ('Sulusaray','60') 
insert into Ilceler(Ad,SehirId) values ('Akçaabat','61') 
insert into Ilceler(Ad,SehirId) values ('Araklý','61') 
insert into Ilceler(Ad,SehirId) values ('Arsin','61') 
insert into Ilceler(Ad,SehirId) values ('Çaykara','61') 
insert into Ilceler(Ad,SehirId) values ('Maçka','61') 
insert into Ilceler(Ad,SehirId) values ('Of','61') 
insert into Ilceler(Ad,SehirId) values ('Sürmene','61') 
insert into Ilceler(Ad,SehirId) values ('Tonya','61') 
insert into Ilceler(Ad,SehirId) values ('Vakfýkebir','61') 
insert into Ilceler(Ad,SehirId) values ('Yomra','61') 
insert into Ilceler(Ad,SehirId) values ('Beþikdüzü','61') 
insert into Ilceler(Ad,SehirId) values ('Þalpazarý','61') 
insert into Ilceler(Ad,SehirId) values ('Çarþýbaþý','61') 
insert into Ilceler(Ad,SehirId) values ('Dernekpazarý','61') 
insert into Ilceler(Ad,SehirId) values ('Düzköy','61') 
insert into Ilceler(Ad,SehirId) values ('Hayrat','61') 
insert into Ilceler(Ad,SehirId) values ('Köprübaþý / Trabzon','61') 
insert into Ilceler(Ad,SehirId) values ('Ortahisar','61') 
insert into Ilceler(Ad,SehirId) values ('Çemiþgezek','62') 
insert into Ilceler(Ad,SehirId) values ('Hozat','62') 
insert into Ilceler(Ad,SehirId) values ('Mazgirt','62') 
insert into Ilceler(Ad,SehirId) values ('Nazýmiye','62') 
insert into Ilceler(Ad,SehirId) values ('Ovacýk / Tunceli','62') 
insert into Ilceler(Ad,SehirId) values ('Pertek','62') 
insert into Ilceler(Ad,SehirId) values ('Pülümür','62') 
insert into Ilceler(Ad,SehirId) values ('Tunceli Merkez','62') 
insert into Ilceler(Ad,SehirId) values ('Akçakale','63') 
insert into Ilceler(Ad,SehirId) values ('Birecik','63') 
insert into Ilceler(Ad,SehirId) values ('Bozova','63') 
insert into Ilceler(Ad,SehirId) values ('Ceylanpýnar','63') 
insert into Ilceler(Ad,SehirId) values ('Halfeti','63') 
insert into Ilceler(Ad,SehirId) values ('Hilvan','63') 
insert into Ilceler(Ad,SehirId) values ('Siverek','63') 
insert into Ilceler(Ad,SehirId) values ('Suruç','63') 
insert into Ilceler(Ad,SehirId) values ('Viranþehir','63') 
insert into Ilceler(Ad,SehirId) values ('Harran','63') 
insert into Ilceler(Ad,SehirId) values ('Eyyübiye','63') 
insert into Ilceler(Ad,SehirId) values ('Haliliye','63') 
insert into Ilceler(Ad,SehirId) values ('Karaköprü','63') 
insert into Ilceler(Ad,SehirId) values ('Banaz','64') 
insert into Ilceler(Ad,SehirId) values ('Eþme','64') 
insert into Ilceler(Ad,SehirId) values ('Karahallý','64') 
insert into Ilceler(Ad,SehirId) values ('Sivaslý','64') 
insert into Ilceler(Ad,SehirId) values ('Ulubey / Uþak','64') 
insert into Ilceler(Ad,SehirId) values ('Uþak Merkez','64') 
insert into Ilceler(Ad,SehirId) values ('Baþkale','65') 
insert into Ilceler(Ad,SehirId) values ('Çatak','65') 
insert into Ilceler(Ad,SehirId) values ('Erciþ','65') 
insert into Ilceler(Ad,SehirId) values ('Gevaþ','65') 
insert into Ilceler(Ad,SehirId) values ('Gürpýnar','65') 
insert into Ilceler(Ad,SehirId) values ('Muradiye','65') 
insert into Ilceler(Ad,SehirId) values ('Özalp','65') 
insert into Ilceler(Ad,SehirId) values ('Bahçesaray','65') 
insert into Ilceler(Ad,SehirId) values ('Çaldýran','65') 
insert into Ilceler(Ad,SehirId) values ('Edremit / Van','65') 
insert into Ilceler(Ad,SehirId) values ('Saray / Van','65') 
insert into Ilceler(Ad,SehirId) values ('Ýpekyolu','65') 
insert into Ilceler(Ad,SehirId) values ('Tuþba','65') 
insert into Ilceler(Ad,SehirId) values ('Akdaðmadeni','66') 
insert into Ilceler(Ad,SehirId) values ('Boðazlýyan','66') 
insert into Ilceler(Ad,SehirId) values ('Çayýralan','66') 
insert into Ilceler(Ad,SehirId) values ('Çekerek','66') 
insert into Ilceler(Ad,SehirId) values ('Sarýkaya','66') 
insert into Ilceler(Ad,SehirId) values ('Sorgun','66') 
insert into Ilceler(Ad,SehirId) values ('Þefaatli','66') 
insert into Ilceler(Ad,SehirId) values ('Yerköy','66') 
insert into Ilceler(Ad,SehirId) values ('Yozgat Merkez','66') 
insert into Ilceler(Ad,SehirId) values ('Aydýncýk / Yozgat','66') 
insert into Ilceler(Ad,SehirId) values ('Çandýr','66') 
insert into Ilceler(Ad,SehirId) values ('Kadýþehri','66') 
insert into Ilceler(Ad,SehirId) values ('Saraykent','66') 
insert into Ilceler(Ad,SehirId) values ('Yenifakýlý','66') 
insert into Ilceler(Ad,SehirId) values ('Çaycuma','67') 
insert into Ilceler(Ad,SehirId) values ('Devrek','67') 
insert into Ilceler(Ad,SehirId) values ('Ereðli','67') 
insert into Ilceler(Ad,SehirId) values ('Zonguldak Merkez','67') 
insert into Ilceler(Ad,SehirId) values ('Alaplý','67') 
insert into Ilceler(Ad,SehirId) values ('Gökçebey','67') 
insert into Ilceler(Ad,SehirId) values ('Kilimli','67') 
insert into Ilceler(Ad,SehirId) values ('Kozlu','67') 
insert into Ilceler(Ad,SehirId) values ('Aksaray Merkez','68') 
insert into Ilceler(Ad,SehirId) values ('Ortaköy / Aksaray','68') 
insert into Ilceler(Ad,SehirId) values ('Aðaçören','68') 
insert into Ilceler(Ad,SehirId) values ('Güzelyurt','68') 
insert into Ilceler(Ad,SehirId) values ('Sarýyahþi','68') 
insert into Ilceler(Ad,SehirId) values ('Eskil','68') 
insert into Ilceler(Ad,SehirId) values ('Gülaðaç','68') 
insert into Ilceler(Ad,SehirId) values ('Bayburt Merkez','69') 
insert into Ilceler(Ad,SehirId) values ('Aydýntepe','69') 
insert into Ilceler(Ad,SehirId) values ('Demirözü','69') 
insert into Ilceler(Ad,SehirId) values ('Ermenek','70') 
insert into Ilceler(Ad,SehirId) values ('Karaman Merkez','70') 
insert into Ilceler(Ad,SehirId) values ('Ayrancý','70') 
insert into Ilceler(Ad,SehirId) values ('Kazýmkarabekir','70') 
insert into Ilceler(Ad,SehirId) values ('Baþyayla','70') 
insert into Ilceler(Ad,SehirId) values ('Sarýveliler','70') 
insert into Ilceler(Ad,SehirId) values ('Delice','71') 
insert into Ilceler(Ad,SehirId) values ('Keskin','71') 
insert into Ilceler(Ad,SehirId) values ('Kýrýkkale Merkez','71') 
insert into Ilceler(Ad,SehirId) values ('Sulakyurt','71') 
insert into Ilceler(Ad,SehirId) values ('Bahþili','71') 
insert into Ilceler(Ad,SehirId) values ('Balýþeyh','71') 
insert into Ilceler(Ad,SehirId) values ('Çelebi','71') 
insert into Ilceler(Ad,SehirId) values ('Karakeçili','71') 
insert into Ilceler(Ad,SehirId) values ('Yahþihan','71') 
insert into Ilceler(Ad,SehirId) values ('Batman Merkez','72') 
insert into Ilceler(Ad,SehirId) values ('Beþiri','72') 
insert into Ilceler(Ad,SehirId) values ('Gercüþ','72') 
insert into Ilceler(Ad,SehirId) values ('Kozluk','72') 
insert into Ilceler(Ad,SehirId) values ('Sason','72') 
insert into Ilceler(Ad,SehirId) values ('Hasankeyf','72') 
insert into Ilceler(Ad,SehirId) values ('Beytüþþebap','73') 
insert into Ilceler(Ad,SehirId) values ('Cizre','73') 
insert into Ilceler(Ad,SehirId) values ('Ýdil','73') 
insert into Ilceler(Ad,SehirId) values ('Silopi','73') 
insert into Ilceler(Ad,SehirId) values ('Þýrnak Merkez','73') 
insert into Ilceler(Ad,SehirId) values ('Uludere','73') 
insert into Ilceler(Ad,SehirId) values ('Güçlükonak','73') 
insert into Ilceler(Ad,SehirId) values ('Bartýn Merkez','74') 
insert into Ilceler(Ad,SehirId) values ('Kurucaþile','74') 
insert into Ilceler(Ad,SehirId) values ('Ulus','74') 
insert into Ilceler(Ad,SehirId) values ('Amasra','74') 
insert into Ilceler(Ad,SehirId) values ('Ardahan Merkez','75') 
insert into Ilceler(Ad,SehirId) values ('Çýldýr','75') 
insert into Ilceler(Ad,SehirId) values ('Göle','75') 
insert into Ilceler(Ad,SehirId) values ('Hanak','75') 
insert into Ilceler(Ad,SehirId) values ('Posof','75') 
insert into Ilceler(Ad,SehirId) values ('Damal','75') 
insert into Ilceler(Ad,SehirId) values ('Aralýk','76') 
insert into Ilceler(Ad,SehirId) values ('Iðdýr Merkez','76') 
insert into Ilceler(Ad,SehirId) values ('Tuzluca','76') 
insert into Ilceler(Ad,SehirId) values ('Karakoyunlu','76') 
insert into Ilceler(Ad,SehirId) values ('Yalova Merkez','77') 
insert into Ilceler(Ad,SehirId) values ('Altýnova','77') 
insert into Ilceler(Ad,SehirId) values ('Armutlu','77') 
insert into Ilceler(Ad,SehirId) values ('Çýnarcýk','77') 
insert into Ilceler(Ad,SehirId) values ('Çiftlikköy','77') 
insert into Ilceler(Ad,SehirId) values ('Termal','77') 
insert into Ilceler(Ad,SehirId) values ('Eflani','78') 
insert into Ilceler(Ad,SehirId) values ('Eskipazar','78') 
insert into Ilceler(Ad,SehirId) values ('Karabük Merkez','78') 
insert into Ilceler(Ad,SehirId) values ('Ovacýk / Karabük','78') 
insert into Ilceler(Ad,SehirId) values ('Safranbolu','78') 
insert into Ilceler(Ad,SehirId) values ('Yenice / Karabük','78') 
insert into Ilceler(Ad,SehirId) values ('Kilis Merkez','79') 
insert into Ilceler(Ad,SehirId) values ('Elbeyli','79') 
insert into Ilceler(Ad,SehirId) values ('Musabeyli','79') 
insert into Ilceler(Ad,SehirId) values ('Polateli','79') 
insert into Ilceler(Ad,SehirId) values ('Bahçe','80') 
insert into Ilceler(Ad,SehirId) values ('Kadirli','80') 
insert into Ilceler(Ad,SehirId) values ('Osmaniye Merkez','80') 
insert into Ilceler(Ad,SehirId) values ('Düziçi','80') 
insert into Ilceler(Ad,SehirId) values ('Hasanbeyli','80') 
insert into Ilceler(Ad,SehirId) values ('Sumbas','80') 
insert into Ilceler(Ad,SehirId) values ('Toprakkale','80') 
insert into Ilceler(Ad,SehirId) values ('Akçakoca','81') 
insert into Ilceler(Ad,SehirId) values ('Düzce Merkez','81') 
insert into Ilceler(Ad,SehirId) values ('Yýðýlca','81') 
insert into Ilceler(Ad,SehirId) values ('Cumayeri','81') 
insert into Ilceler(Ad,SehirId) values ('Gölyaka','81') 
insert into Ilceler(Ad,SehirId) values ('Çilimli','81') 
insert into Ilceler(Ad,SehirId) values ('Gümüþova','81') 
insert into Ilceler(Ad,SehirId) values ('Kaynaþlý','81')

insert into KanGruplari(KanGrubu) values('A+')
insert into KanGruplari(KanGrubu) values('A-')
insert into KanGruplari(KanGrubu) values('B+')
insert into KanGruplari(KanGrubu) values('B-')
insert into KanGruplari(KanGrubu) values('AB+')
insert into KanGruplari(KanGrubu) values('AB-')
insert into KanGruplari(KanGrubu) values('0+')
insert into KanGruplari(KanGrubu) values('0-')

insert into Gorevler(Pozisyon) values('Resepsiyon Görevlisi')
insert into Gorevler(Pozisyon) values('Temizlik Görevlisi')
insert into Gorevler(Pozisyon) values('Aþçý')
insert into Gorevler(Pozisyon) values('Garson')
insert into Gorevler(Pozisyon) values('Elektirikçi')
insert into Gorevler(Pozisyon) values('Bilgi Ýþlem Sorumlusu')
insert into Gorevler(Pozisyon) values('Yönetici')

insert into Maaslar(MaasTanimi,Maas) values ('Þef Garson Saatlik',18)
insert into Maaslar(MaasTanimi,Maas) values ('Garson Saatlik',12)
insert into Maaslar(MaasTanimi,Maas) values ('Master Aþçý Saatlik',30)
insert into Maaslar(MaasTanimi,Maas) values ('Aþçý Yamaðý',12)
insert into Maaslar(MaasTanimi,Maas) values ('Temizlik Görevlisi',13)
insert into Maaslar(MaasTanimi,Maas) values ('Elektirik Teknisyeni',15)
insert into Maaslar(MaasTanimi,Maas) values ('IT Melih Bey',25)
insert into Maaslar(MaasTanimi,Maas) values ('Resepsiyon Görevlisi',12)
insert into Maaslar(MaasTanimi,Maas) values ('Ýnsan Kaynaklarý',3500)
insert into Maaslar(MaasTanimi,Maas) values ('Satýþ Departmaný',4000)
go
create function fn_TarihConvert
(
	@Tarih nvarchar(10)
)
returns date
begin
	declare @gun nvarchar(2)
	declare @ay nvarchar(2)
	declare @yýl nvarchar(4)
	set @gun = SUBSTRING(@Tarih,1,2)
	set @ay=SUBSTRING(@Tarih,4,2)
	set @yýl=SUBSTRING(@Tarih,7,4)
	return @ay+'-'+@gun+'-'+@yýl
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
	@GorevAdý nvarchar(30),
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
		(select Id from Gorevler where Pozisyon=@GorevAdý),
		(select Id from Maaslar where MaasTanimi=@MaasTanimi),
		(select Id from KanGruplari where KanGrubu=@KanGrubu),
		@TcNo,@Ad,@Soyad,@Cinsiyet,dbo.fn_TarihConvert(@DogumTarihi),dbo.fn_TarihConvert(@GirisTarihi),null,@Email
	)
end
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'A+', '46518648315','Mehmet','Tuna','E','11-10-1990','03-12-2020','mehmettn@gmail.com'
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'A-', '48531564123','Ahmet','Öksüz','E','11-01-1993','03-12-2020','ahmetoksuz@gmail.com'
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'A+', '54615648153','Serkan','Bayraktar','E','25-04-1995','03-12-2020','serkanbayraktar@gmail.com' 
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'AB+', '46518648315','Serpil','Çelik','K','25-10-1992','03-12-2020','serpilcelik@gmail.com' 
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', '0+', '46518648315','Dilek','Güllü','K','12-12-1986','03-12-2020','dilekgullu@gmail.com'
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'A+', '46518648315','Sevda','Canpolat','K','01-05-1998','03-12-2020','sevdacanplt@gmail.com' 
go
exec CalisanEkle 'Resepsiyon Görevlisi', 'Resepsiyon Görevlisi', 'A+', '46518648315','Gamze','Çalýþan','K','17/11/1995','03-12-2020','gamzecalisan@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A+', '85654541554','Nermin','Çolak','K','25/05/1987','03-12-2020','nermincolak@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', '0+', '18451864644','Fatih','Yýldýrým','E','25/01/1978','03-12-2020','fatihyildirim@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A+', '46545895355','Mert','Atmaca','E','09/11/1991','03-12-2020','mertatmaca@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A-', '56465456564','Mahmut','Mahmutoðlu','E','28/10/1975','03-12-2020','mahmutoglu@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', '0+', '56465456564','Gülseren','Beker','K','02/10/1975','03-12-2020','gulserenbeker@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A-', '56465456564','Mumin','Lüksekaçmaz','E','26/09/1994','03-12-2020','luksekacmazmumin@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', '0+', '56465456564','Gülsüm','Atlý','K','06/06/1982','03-12-2020','gulsum@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', '0-', '56465456564','Fatih','Dönmez','E','15/07/1992','03-12-2020','fatihdonmez@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'AB+', '56465456564','Sinem','Çýkrýkçý','K','11/10/1990','03-12-2020','mertatmaca@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A-', '56465456564','Emre','Yýldýrým','E','05/08/1998','03-12-2020','emreyildirim@gmail.com'
go
exec CalisanEkle 'Temizlik Görevlisi', 'Temizlik Görevlisi', 'A+', '56465456564','Sultan','Akgün','K','06/07/1975','03-12-2020','sultanakgun@gmail.com'
go
exec CalisanEkle 'Bilgi Ýþlem Sorumlusu', 'IT Melih Bey', 'A+', '48454654846','Melih','Bektaþ','E','05/08/1992','03-12-2020','melihbektas@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A+','27898712314','Erol', 'Baþtuð', 'E','11-06-1981','03.12.2020', 'erolbastug@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik','A+','75295145635', 'DENÝZ','KURUKAFA','E',	'12 08 1991','03.12.2020',	'denizkurukafa@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik','B+', '22706153422', 'EMÝNE', 'PALA',  'K', '10.02.1989', '03.12.2020', 'eminepala@gmail.com'
go 
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB+', '84389486730','YUNUS','KUÞKONMAZ', 'E',	'02.01.1991', '03.12.2020', 'yunuskuskonmaz@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', '0+', '45104943976', 'EYÜP', 'AKDEMÝR', 'E', '11.02.1991','03.12.2020', 	'eyüpakdemir@gmail.com'
go 
exec CalisanEkle 'Garson', 'Garson Saatlik', 'B+',	'12104943976', 'SEVDA', 'ÞENER', 'K',	'01.07.1990',	'04.12.2020', 'sevdasener@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A-', '24504943976', 'UÐUR','NAS', 'E', '19.10.1990',	'05.12.2020', 'ugurnas@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB-',	'69104943976', 'EVÝN', 'ÇAKAN', 'K', '08.08.1991', '06.12.2020', 	'evincan@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'B-', '31104943976', 'MURAT', 'TUNA', 'E',	'13.02.1988', '06.12.2020', 'murattuna@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'A+',	'42295145635', 'MERYEM', 'TOPAL','K', '10.05.1990', '06.12.2020', 'meryemtopal@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', '0-',	'63295145635', 'BURAK', 'SEKMEN', 'E',	'01.01.1991', '05.12.2020', 'buraksekmen@gmail.com'
go
exec CalisanEkle 'Garson', 'Garson Saatlik', 'AB+',	'95295145635',	'TANER', 'KORUN', 'E', '15.11.1989', '6.12.2020', 'tanerkorun@gmail.com'
go
exec CalisanEkle 'Garson',	'Garson Saatlik', 'A+', '15295145635', 'FATÝH', 'SAPAN', 'E', '02.11.1991', '5.12.2020', 'fatihsapan@gmail.com'	
go

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('Her þey dahil paket indirimi', '0.18', '30', '1')

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('Tam pansiyon paket indirimi', '0.16', '30', '1')

insert into IndirimTanimlari(IndirimAdi, IndirimOrani, GunSayisi, AktifMi) 
values ('90 gün indirimi', '0.23', '90', '1')

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Sadece Konaklama/Peþin Ödeme', 400)

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Oda+KAhvaltý/Peþin Ödeme',580)

insert into HizmetPaketleri(Ad,Fiyat) 
values ('Sadece Konaklama/Otelde Ödeme', 480)

insert into HizmetPAketleri(Ad,Fiyat) 
values ('Oda+Kahvaltý/Otelde Ödeme', 640)



insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Superior King', 'OdaÞehir manzarasýna sahip, her biri 29 metrekarelik 178 adet Superior Oda yüksek standartlarý ile konforlu bir deneyim vadediyor.', 8)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Deluxe King Yataklý', 'Sadeliði konfor ve teknolojiyle birleþtiren, 29 metrekarelik, tamamý deniz manzaralý 32 adet Deluxe Oda, Ýstanbul’un eþsiz eðlencesinden veya yoðun bir iþ temposundan sonra sizi rahat ettirmek için tasarlanmýþ.', 8)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Executive King Yataklý', 'Adalar ve deniz manzarasýna sahip, 29 metrekarelik 19 adet Executive Oda, konfor ve lüksün somut bir örneðini sunarken tüm beklentilerinizi karþýlýyor.', 7)

insert into OdaTipleri(Ad,Aciklama,OdaPuan)
values ('Lounge Eriþimli Executive Süit', 'Muhteþem deniz manzaralý, 60 metrekarelik geniþ bir alana kurulu 9 adet Executive Süit, modern tasarýmlarýyla þýk ve ferah bir konaklama deneyimi yaþatýyor.', 9)

insert into OdaImkanlari(Ad)
values ('Klima')
insert into OdaImkanlari(Ad)
values ('Dýþ Hatlý Telefon')
insert into OdaImkanlari(Ad)
values ('Saç Kurutma Makinesi')
insert into OdaImkanlari(Ad)
values ('Çamaþýrhane Hizmeti')
insert into OdaImkanlari(Ad)
values ('Ýnternet Eriþimi(yüksek Hýzlý)')
insert into OdaImkanlari(Ad)
values ('Ütü ve ütü masasý(istek üzerine)')
insert into OdaImkanlari(Ad)
values ('Minibar')
insert into OdaImkanlari(Ad)
values ('Özel banyo-tuvalet')
insert into OdaImkanlari(Ad)
values ('Kasa')
insert into OdaImkanlari(Ad)
values ('TV')
insert into OdaImkanlari(Ad)
values ('Havuz Havlusu')
insert into OdaImkanlari(Ad)
values ('Deniz Manzarasý')
insert into OdaImkanlari(Ad)
values ('Bornoz')
insert into OdaImkanlari(Ad)
values ('Masa')

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Superior King'),1)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Deluxe King Yataklý'),2)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Executive King Yataklý'),3)

insert into Odalar(OdaTipiId,Kat)
values ((select Id from OdaTipleri where Ad='Lounge Eriþimli Executive Süit'),4)


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
insert into VardiyaTipleri(Ad,BaslamaSaati,BitisSaati) values ('Akþam', '16:00', '00:00')
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





