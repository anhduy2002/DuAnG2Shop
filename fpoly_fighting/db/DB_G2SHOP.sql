use master
go

drop database G2SHOP
go

create database G2SHOP
go

use G2SHOP
go

create table roles
(
	id						int					primary key ,
	[name]					nvarchar( 20 )		not null unique
)

create table users
(
	id						int					primary key identity ,
	username				varchar( 50 )		not null unique ,
	fullname				nvarchar( 50 )		not null ,
	hashPassword			varchar( 255 )		not null ,
	email					varchar( 100 )		not null unique ,
	phone					varchar( 12 )		not null unique , 
	[address]				nvarchar( 255 )		not null ,
	createdDate				datetime			not null default getdate() ,
	resetPasswordCode		varchar( 64 )		null ,
	isEnabled				bit					not null default 0 ,
	isDeleted				bit					not null default 0 ,
	roleId					int					foreign key references roles( id ) ,
)

create table categories
(
	id						int					primary key identity,
	[name]					nvarchar( 50 )		not null,
	slug					varchar( 255 )		not null unique,
	imageName				varchar( 255 )		null,
	isDeleted				bit					not null default 0
)

create table brands
(
	id						int					primary key identity ,
	[name]					nvarchar( 50 )		not null ,
	slug					varchar( 255 )		not null unique ,
	imageName				varchar( 255 )		null ,
	isDeleted				bit					not null default 0
)

create table products
(
	id						int					primary key identity ,
	[name]					nvarchar( 255 )		not null ,
	quantity				int					not null check( quantity >= 0 ) ,
	discount				int					not null check( discount >= 0 and discount < 100 ) ,
	price					decimal( 12 , 3 )	not null check( price > 0 ) ,
	imageName				varchar( 255 )		null default 'main.jpg' ,
	image1Name				varchar( 255 )		null ,
	image2Name				varchar( 255 )		null ,
	image3Name				varchar( 255 )		null ,
	image4Name				varchar( 255 )		null ,
	image5Name				varchar( 255 )		null ,
	[description]			ntext				null ,
	slug					varchar( 255 )		not null unique ,
	viewCount				int					not null default 0 check( viewcount >= 0 ) ,
	isDeleted				bit					not null default 0 ,
	categoryId				int					foreign key references categories( id ) ,
	brandId					int					foreign key references brands( id ) ,
)

create table favorites
(
	id						int					primary key identity ,
	isCanceled				bit					not null default 0 ,
	createdDate				datetime			not null default getdate() ,
	customerId				int					foreign key references users( id ) ,
	productId				int					foreign key references products( id )
)

create table order_statuses
(
	id						int					primary key ,
	[name]					nvarchar( 50 )		not null
)

create table orders
(
	id						int					primary key identity ,
	createdDate				datetime			not null default getdate() ,
	receiverFullname		nvarchar( 50 )		not null ,				
	receiverPhone			varchar( 12 )		not null ,
	receiverAddress			nvarchar( 255 )		not null ,
	receivedDate			datetime			null ,
	shippingFee				decimal( 12 , 3 )	not null default 0 check( shippingFee >= 0 ) ,
	note					nvarchar( 255 )		null ,
	customerId				int					foreign key references users( id ) ,
	confirmingStaffId		int					foreign key references users( id ) ,
	shippingStaffId			int					foreign key references users( id ) ,
	orderStatusId			int					foreign key references order_statuses( id )
)

create table order_details
(
	id						bigint				primary key identity,
	price					decimal( 12 , 3 )	not null check( price > 0 ),
	quantity				int					not null check( quantity > 0 ),
	orderId					int					foreign key references orders( id ),
	productId				int					foreign key references products( id ),
)

create table basic_information
(
	id						int					primary key identity,
	title					nvarchar( 50 )		not null ,
	phone					varchar( 12 )		not null ,
	phone2					varchar( 12 )		null ,
	email					varchar( 100 )		not null ,
	[address]				nvarchar( 255 )		not null ,
	embedAddressCode		ntext				not null ,
	embedHelpYoutubeVideoIds	text			null ,
	termsAndPolicies		ntext				null
)

create table website_visits
(
	id						int					primary key identity,
	[date]					date				not null unique,
	visitCount				int					not null default 0 check( visitCount >= 0)
)

create table news
(
	id						int					primary key identity,
	createdDate				datetime			not null default getdate() ,
	title					nvarchar( 255 )		not null ,
	imageName				varchar( 255 )		null ,
	content					ntext				not null ,
	isShowedOnHomepage		bit					not null default 1 ,
	isDeleted				bit					not null default 0
)

go

ALTER TABLE basic_information
ADD CONSTRAINT UQ_Phone_Phone2 UNIQUE(phone, phone2)

go

-- insert
insert into order_statuses ( id , [name] ) values
( -1 , N'Đã hủy'			) ,
( 0 , N'Chưa xác nhận'		) ,
( 1 , N'Đã xác nhận'		) ,
( 2 , N'Đang lấy hàng'		) ,
( 3 , N'Đang vận chuyển'	) ,
( 4 , N'Đợi thanh toán'		) ,
( 5 , N'Hoàn tất'			)
go

insert into roles ( id , [name] ) values
( 1	, N'Khách hàng' 			) ,
( 2	, N'Quản lý' 				) ,
( 3	, N'Nhân viên bán hàng' 	) ,
( 4	, N'Nhân viên giao hàng' 	)
go

SET IDENTITY_INSERT users ON
-- staffs
insert into users ( id , username , fullname , hashPassword , email , phone , [address] , createdDate , isEnabled , roleId ) values
( 1	, N'g2annv'		, N'Nguyễn Văn An' 		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'annv.g2@gmail.com'		, '0325009179' , N'306 Nguyễn Trãi, P.8, Q.5, TP.HCM' , '2021-01-01' , 1 , 2 ) ,
( 2	, N'g2phuongdd'	, N'Đào Duy Phương'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'phuongdd.g2@gmail.com'	, '0936239380' , N'412 Lê Văn Sỹ, P.14, Q.3, TP.HCM' , '2021-01-01' , 1 , 2 ) ,
( 3	, N'g2cuclt'	, N'Lê Thị Cúc'			, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'cuclt.g2@gmail.com'	, '0353000755' , N'100 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '2021-01-01' , 1 , 3 ) ,
( 4	, N'g2mydd'		, N'Đỗ Diễm My'			, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'mydd.g2@gmail.com'		, '0932092503' , N'153 Quang Trung, P.10, Q.Gò Vấp, TP.HCM' , '2021-01-01' , 1 , 3 ) ,
( 5	, N'g2hieunm'	, N'Nguyễn Minh Hiếu'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'hieunm.g2@gmail.com'	, '0932156308' , N'130 Quang Trung, P.10, Q.Gò Vấp, TP.HCM' , '2021-01-01' , 1 , 4 ) ,
( 6	, N'g2laptd'	, N'Trần Duy Lập' 		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'laptd.g2@gmail.com'		, '0394777229' , N'48 Tô Vĩnh Diện, TP Thủ Đức' , '2021-01-01' , 1 , 4 ) ,
-- customers
( 7	, N'anhnhan'	, N'Huỳnh Anh Nhân'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'anhnhan@gmail.com'		, '0936529660' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 8	, N'ngando'		, N'Đỗ Kim Ngân'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'ngando@gmail.com'		, '0931698210' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 9	, N'tile'		, N'Lê Văn Tí'			, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'tile@gmail.com'			, '0386382227' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 10, N'nhanhuynh'	, N'Huỳnh Trúc Nhân'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'nhanhuynh@gmail.com'	, '0932838520' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 11, N'huytran'	, N'Trần Thái Huy'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'huytran@gmail.com'		, '0931119261' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 12, N'phonghuynh' , N'Huỳnh Phong'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'phonghuynh@gmail.com'	, '0397007771' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 13, N'taile'		, N'Lê Tiến Tài'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'taile@gmail.com'		, '0931062650' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '2021-05-01' , 1 , 1 ) ,
( 14, N'lenguyen'	, N'Nguyễn Thị Diễm Lệ'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'lenguyen@gmail.com'		, '0931056811' , N'25 Trần Quang Diệu p.14, Q.3, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 15, N'minhdang'	, N'Đặng Anh Minh'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'minhdang@gmail.com'		, '0369206660' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '2021-05-01' , 1 , 1 ) ,
( 16, N'namvo'		, N'Võ Nhật Nam'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'namvo@gmail.com'		, '0363922237' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '2021-05-01' , 1 , 1 )
go
SET IDENTITY_INSERT users OFF
go

SET IDENTITY_INSERT categories ON
insert into categories ( id , [name] , slug , imageName ) values
( 1	, N'Nồi cơm điện'				, 'noi-com-dien'		, '1.png' ) ,
( 2	, N'Bếp các loại'				, 'bep-cac-loai'		, '2.png' ) ,
( 3	, N'Lò vi sóng - lò nướng'		, 'lo-vi-song-lo-nuong'	, '3.png' ) ,
( 4	, N'Máy xay sinh tố'			, 'may-xay-sinh-to'		, '4.png' ) ,
( 5	, N'Lọc không khí'				, 'loc-khong-khi'		, '5.png' ) ,
( 6 , N'Hút bụi'					, 'hut-bui'				, '6.png' ) ,
( 7	, N'Máy lọc nước'				, 'may-loc-nuoc'		, '7.png' )
go

SET IDENTITY_INSERT categories OFF 
go

SET IDENTITY_INSERT brands ON
insert into brands ( id , [name] , slug , imageName ) values
( 1		, N'Cuckoo' 	, 'cuckoo'		, '1.png' ) ,
( 2		, N'Kangaroo' 	, 'kangaroo' 	, '2.png' ) ,
( 3		, N'LG' 		, 'lg' 			, '3.png' ) ,
( 4		, N'Panasonic' 	, 'panasonic' 	, '4.png' ) ,
( 5		, N'Samsung' 	, 'samsung' 	, '5.png' ) ,
( 6		, N'Sanaky' 	, 'sanaky' 		, '6.png' ) ,
( 7		, N'Sharp' 		, 'sharp' 		, '7.png' ) ,
( 8		, N'Sunhouse' 	, 'sunhouse' 	, '8.png' ) ,
( 9		, N'Toshiba' 	, 'toshiba' 	, '9.png' ) ,
( 10 	, N'Khác' 		, 'khac' 		, null	)
SET IDENTITY_INSERT brands OFF
go

SET IDENTITY_INSERT products ON
insert into products ( id , [name] , quantity , discount , price , [description] , slug , image1Name , image2Name , image3Name , image4Name , image5Name , categoryId , brandId ) values

-- Nồi cơm điện
-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-nap-gai-kangaroo-kg835-18l
( 
	1 , 
	N'Nồi cơm điện nắp gài Kangaroo 1.8 lít S1' ,
	100 , 40 , 1380000 ,
	N'' ,
	'noi-com-dien-nap-gai-kangaroo-1.8-lit-s1' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/kangaroo-kg378h-18-lit
( 
	2 , 
	N'Nồi cơm điện nắp gài Kangaroo 1.8 lít S2' ,
	100 , 7 , 840000 ,
	N'' ,
	'noi-com-dien-nap-gai-kangaroo-1.8-lit-s2' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-sunhouse-shd8607w
( 
	3 , 
	N'Nồi cơm điện nắp gài Sunhouse 1.8 lít S3' ,
	100 , 18 , 950000 ,
	N'' ,
	'noi-com-dien-nap-gai-sunhouse-1.8-lit-s3' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	1 , 8
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-toshiba-rc-18jh2pv-b-18l
( 
	4 , 
	N'Nồi cơm điện nắp gài Toshiba 1.8 lít S4' ,
	100 , 5 , 820000 , 
	N'' ,
	'noi-com-dien-nap-gai-toshiba-18-lit-s4' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 9
) ,

-- https://www.dienmayxanh.com/noi-com-dien/sharp-ksh-d15v
( 
	5 , 
	N'Nồi cơm điện Sharp 1.5 lít S5' ,
	100 , 5 , 700000 , 
	N'' ,
	'noi-com-dien-sharp-15-lit-s5' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	1 , 7
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-roi-sunhouse-shd8135
( 
	6 , 
	N'Nồi cơm điện Sunhouse 2.2 lít S6' ,
	100 , 5 , 890000 , 
	N'' ,
	'noi-com-dien-sunhouse-22-lit-s6' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	1 , 8
) ,

-- https://www.dienmayxanh.com/noi-com-dien/cuckoo-crp-pk1000s-18-lit
( 
	7 , 
	N'Nồi cơm điện tử áp suất Cuckoo 1.8 lít S7' ,
	100 , 10 , 4369000 ,
	N'' ,
	'noi-com-dien-tu-ap-suat-cuckoo-18-lit-s7' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 1
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-tu-ap-suat-mishio-1-lit-mk-303
( 
	8 , 
	N'Nồi cơm điện tử áp suất Mishio 1 lít S8' ,
	100 , 10 , 1990000 , 
	N'' ,
	'noi-com-dien-tu-ap-suat-mishio-18-lit-s8' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 10
) ,

-- https://www.dienmayxanh.com/noi-com-dien/cao-tan-kangaroo-kg599n
( 
	9 , 
	N'Nồi cơm điện cao tần Kangaroo 1.8 lít S9' ,
	100 , 19 , 3280000 , 
	N'' ,
	'noi-com-dien-cao-tan-kangaroo-18-lit-s9' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/dien-tu-toshiba-rc-18rh-cg-vn
( 
	10 , 
	N'Nồi cơm điện cao tần Toshiba 1.8 lít S10' ,
	100 , 6 , 5990000 , 
	N'' ,
	'noi-com-dien-cao-tan-toshiba-18-lit-s10' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 9
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-tu-panasonic-sr-cp188nra
( 
	11 , 
	N'Nồi cơm điện tử Panasonic 1.8 lít S11' ,
	100 , 11 , 2570000 , 
	N'',
	'noi-com-dien-tu-panasonic-18-lit-s11' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 4
) ,

-- https://www.dienmayxanh.com/noi-com-dien/tu-hommy-12-lit-bmb-30a
( 
	12 , 
	N'Nồi cơm điện tử Hommy 1.2 lít S12' ,
	100 , 27 , 1450000 , 
	N'' ,
	'noi-com-dien-tu-hommy-12-lit-s12' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	1 , 10
) ,

-- https://www.dienmayxanh.com/noi-com-dien/sharp-ks-18tjv
( 
	13 , 
	N'Nồi cơm điện Sharp 1.8 lít S13' ,
	100 , 11 , 680000 , 
	N'' ,
	'noi-com-dien-sharp-18-lit-s13' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	1 , 7
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-sunhouse-shd8208c-cafe
( 
	14 , 
	N'Nồi cơm nắp gài Sunhouse 1 lít S14' ,
	100 , 20 , 790000 , 
	N'' ,
	'noi-com-nap-gai-sunhouse-1-lit-s14' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	1 , 8
) ,



-- Bếp các loại
-- https://www.dienmayxanh.com/bep-tu/crystal-ly-t39
( 
	15 , 
	N'Bếp từ Crystal S15' ,
	100 , 45 , 1859000 , 
	N'' ,
	'bep-tu-crystal-s15' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-kangaroo-kg408i
( 
	16 , 
	N'Bếp từ Kangaroo S16' ,
	100 , 31 , 1890000 , 
	N'' ,
	'bep-tu-kangaroo-s16' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/sunhouse-shd6867
( 
	17 , 
	N'Bếp từ đơn Sunhouse S17' ,
	100 , 14 , 1490000 , 
	N'' ,
	'bep-tu-don-sunhouse-s17' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-kangaroo-kg15ic1
( 
	18 , 
	N'Bếp điện từ Kangaroo S18' ,
	100 , 26 , 1080000 , 
	N'' ,
	'bep-dien-tu-kangaroo-s18' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/kangaroo-kg499n
( 
	19 , 
	N'Bếp từ hồng ngoại lắp âm Kangaroo S19' ,
	100 , 26 , 4030000 , 
	N'' ,
	'bep-tu-hong-ngoai-lap-am-kangaroo-s19' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/toshiba-ic-20s4pv
( 
	20 , 
	N'Bếp từ Toshiba S20' ,
	100 , 6 , 1690000 , 
	N'' ,
	'bep-tu-toshiba-s20' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 9
) ,


-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-hong-ngoai-sunhouse-shb9105mt
( 
	21 , 
	N'Bếp từ hồng ngoại lắp âm Sunhouse S21' ,
	100 , 30 , 4190000 , 
	N'' ,
	'bep-tu-hong-ngoai-lap-am-sunhouse-s21' ,
	'1.jpg' , '' , '' , '' , '' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-tu/be-p-tu-sunhouse-shd6159
( 
	22 , 
	N'Bếp từ Sunhouse S22' ,
	100 , 5 , 1040000 , 
	N'' ,
	'bep-tu-sunhouse-s22' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/sunhouse-shd-6005-emc
( 
	23 , 
	N'Bếp hồng ngoại Sunhouse S23' ,
	100 , 14 , 1100000 , 
	N'' ,
	'bep-hong-ngoai-sunhouse-s23' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/smeg-se363etb-53664101
( 
	24 , 
	N'Bếp hồng ngoại 3 vùng nấu lắp âm Smeg S24' ,
	100 , 15 , 27290000 , 
	N'' ,
	'bep-hong-ngoai-3-vung-nau-lap-am-smeg-s24' ,
	'1.jpg' , '' , '' , '' , '' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/smeg-se332eb-53564241
( 
	25 , 
	N'Bếp hồng ngoại đôi lắp âm Smeg S25' ,
	100 , 15 , 20990000 , 
	N'' ,
	'bep-hong-ngoai-doi-lap-am-smeg-s25' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/torino-tc0418c
( 
	26 , 
	N'Bếp hồng ngoại đôi lắp âm Torino S26' ,
	100 , 0 , 9900000 , 
	N'' ,
	'bep-hong-ngoai-doi-lap-am-torino-s26' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	2 , 10
) ,




-- Lò

-- https://www.dienmayxanh.com/lo-nuong/sharp-eo-a384rcsv-st
( 
	27 , 
	N'Lò nướng Sharp 38 lít S27' ,
	100 , 15 , 3090000 ,
	N'' ,
	'lo-nuong-sharp-38-lit-s27' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 7
) ,

-- https://www.dienmayxanh.com/lo-nuong/kangaroo-kg4001-40-lit
( 
	28 , 
	N'Lò nướng Kangaroo 40 lít S28' ,
	100 , 13 , 3110000 , 
	N'' ,
	'lo-nuong-kangaroo-40-lit-s28' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 2
) ,

-- https://www.dienmayxanh.com/lo-nuong/sanaky-vh5099s2d-50-lit
( 
	29 , 
	N'Lò nướng Sanaky 50 lít S29' ,
	100 , 6 , 2769000 , 
	N'' ,
	'lo-nuong-sanaky-50-lot-s29' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 6
) ,

-- https://www.dienmayxanh.com/lo-nuong/lo-nuong-sharp-eo-b46rcsv-bk
( 
	30 , 
	N'Lò nướng Sharp 46 lít S30' ,
	100 , 0 , 2600000 , 
	N'' ,
	'lo-nuong-sharp-46-lit-s30' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 7
) ,

-- https://www.dienmayxanh.com/lo-nuong/lo-nuong-bluestone-eob-7548
( 
	31 , 
	N'Lò nướng Bluestone 38 lít S31' ,
	100 , 10 , 2599000 , 
	N'' ,
	'lo-nuong-bluestone-38-lit-s31' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 10
) ,

-- https://www.dienmayxanh.com/lo-nuong/sunhouse-mama-shd4240-40-lit
( 
	32 , 
	N'Lò nướng Sunhouse Mama 40 lít S32' ,
	100 , 0 , 2410000 , 
	N'' ,
	'lo-nuong-sunhouse-mama-40-lit-s32' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 8
) ,

-- https://www.dienmayxanh.com/lo-vi-song/panasonic-nn-sm33hmyue

( 
	56 , 
	N'Lò vi sóng Panasonic 25 lít S56' ,
	100 , 11 , 2690000 , 
	N'' ,
	'lo-vi-song-panasonic-25-lit-s56' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 4
) ,

-- https://www.dienmayxanh.com/lo-vi-song/panasonic-nn-st25jwyue

( 
	57 , 
	N'Lò vi sóng Panasonic 29 lít S57' ,
	100 , 10 , 2610000 , 
	N'' ,
	'lo-vi-song-panasonic-29-lit-s57' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 4
) ,

-- https://www.dienmayxanh.com/lo-vi-song/sharp-r-g371vn-w

( 
	58 , 
	N'Lò vi sóng có nướng Sharp 23 lít S58' ,
	100 , 10 , 2650000 , 
	N'' ,
	'lo-vi-song-co-nuong-sharp-23-lit-s58' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 7
) ,

-- https://www.dienmayxanh.com/lo-vi-song/lo-vi-song-toshiba-er-sgm20-s1-vn

( 
	59 , 
	N'Lò vi sóng có nướng Toshiba S59' ,
	100 , 6 , 2450000 , 
	N'' ,
	'lo-vi-song-co-nuong-toshiba-20-lit-s59' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	3 , 9
) ,

-- Máy xay sinh tố

-- https://www.dienmayxanh.com/may-xay-sinh-to/sunhouse-shd-5112-xanh
( 
	33 , 
	N'Máy xay sinh tố đa năng Sunhouse Xanh S33' ,
	100 , 17 , 510000 , 
	N'' ,
	'may-xay-sinh-to-da-nang-sunhouse-xanh-s33' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	4 , 8
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/may-xay-sinh-to-toshiba-mx-60t-h#2-gia
( 
	34 , 
	N'Máy xay sinh tố đa năng Toshiba S34' ,
	100 , 6 , 890000 , 
	N'' ,
	'may-xay-sinh-to-da-nang-toshiba-s34' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	4 , 9
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/sharp-em-s155pv-wh
( 
	35 , 
	N'Máy xay sinh tố đa năng Sharp S35' ,
	100 , 10 , 949000 , 
	N'' ,
	'may-xay-sinh-to-da-nang-sharp-s35' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	4 , 7
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/panasonic-mx-mg53c1cra
( 
	36 , 
	N'Máy xay sinh tố đa năng Panasonic S36' ,
	100 , 5 , 1800000 , 
	N'' ,
	'may-xay-sinh-to-da-nang-panasonic-s36' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	4 , 4
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/may-xay-nau-da-nang-kangaroo-kg175hb1
( 
	37 , 
	N'Máy xay nấu đa năng Kangaroo S37' ,
	100 , 14 , 3420000 , 
	N'' ,
	'may-xay-nau-da-nang-kangaroo-s37' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '' , '' ,
	4 , 2
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/kangaroo-kgbl600x
( 
	38 , 
	N'Máy xay sinh tố Kangaroo S38' ,
	100 , 25 , 1490000 , 
	N'' ,
	'may-xay-sinh-to-kangaroo-s38' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	4 , 2
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/may-xay-sinh-to-sunhouse-mama-shd5353
( 
	60 , 
	N'Máy xay sinh tố đa năng Sunhouse Mama S60' ,
	100 , 15 , 1720000 , 
	N'' ,
	'may-xay-sinh-to-da-nang-sunhouse-mama-s60' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	4 , 8
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/kangaroo-kgbl600x
( 
	61 , 
	N'Máy xay Kangaroo S61' ,
	100 , 9 , 1490000 , 
	N'' ,
	'may-xay-kangaroo-s61' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	4 , 2
) ,


-- Lọc không khí
-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-kangaroo-kg40ap
( 
	39 , 
	N'Máy lọc không khí Kangaroo 50W S39' ,
	100 , 14 , 6824000 , 
	N'' ,
	'may-loc-khong-khi-kangaroo-50w-s39' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	5 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-sharp-fp-j80ev-h
( 
	40 , 
	N'Máy lọc không khí Sharp 48W S40' ,
	100 , 8 , 8390000 , 
	N'' ,
	'may-loc-khong-khi-sharp-48w-s40' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	5 , 7
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/sunhouse-shd-35ap9735
( 
	41 , 
	N'Máy lọc không khí Sunhouse 50W S41' ,
	100 , 25 , 4310000 , 
	N'' ,
	'may-loc-khong-khi-sunhouse-50w-s41' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	5 , 8
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-samsung-ax60r5080wd-sv
( 
	42 , 
	N'Máy lọc không khí Samsung 60W S42' ,
	100 , 6 , 10190000 , 
	N'' ,
	'may-loc-khong-khi-samsung-60w-s42' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	5 , 5
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-lg-puricare-aerotower-mau-xanh-la
( 
	43 , 
	N'Máy lọc không khí LG PuriCare AeroTower màu xanh lá 50W S43' ,
	100 , 7 , 22500000 , 
	N'' ,
	'may-loc-khong-khi-lg-puricare-aerotower-xanh-la-50w-s43' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '' , '' ,
	5 , 3
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/cuckoo-cac-g0910fn
( 
	44 , 
	N'Máy lọc không khí Cuckoo 50W S44' ,
	100 , 29 , 4050000 , 
	N'' ,
	'may-loc-khong-khi-cuckoo-50w-s44' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	5 , 1
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-sharp-fp-jm40v-b
( 
	62 , 
	N'Máy lọc không khí Sharp 23W S62' ,
	100 , 29 , 4050000 , 
	N'' ,
	'may-loc-khong-khi-sharp-23w-s62' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	5 , 7
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/lg-as40gwwj1
( 
	63 , 
	N'Máy lọc không khí LG Puricare Pro 32W S63' ,
	100 , 8 , 5800000 , 
	N'' ,
	'may-loc-khong-khi-lg-puricare-pro-32w-s63' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5,jpg' ,
	5 , 3
) ,



-- Hút bụi
-- https://www.dienmayxanh.com/robot-hut-bui/samsung-vr30t85513w-sv
( 
	45 , 
	N'Robot hút bụi Samsung S45' ,
	100 , 10 , 19990000 , 
	N'' ,
	'robot-hut-bui-samsung-s45' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/may-hut-bui/cam-tay-samsung-vs15a6031r1-sv
( 
	46 , 
	N'Máy hút bụi không dây Samsung S46' ,
	100 , 6 , 7990000 , 
	N'' ,
	'may-hut-bui-khong-day-samsung-s46' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/may-hut-bui/philips-fc6728
( 
	47 , 
	N'Máy hút bụi không dây Philips S47' ,
	100 , 35 , 10499000 , 
	N'' ,
	'may-hut-bui-khong-day-philips-s47' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '' , '' ,
	6 , 10
) ,

-- https://www.dienmayxanh.com/may-hut-bui/may-hut-bui-khong-day-panasonic-mc-sb30jw049
( 
	48 , 
	N'Máy hút bụi không dây Panasonic S48' ,
	100 , 0 , 7690000 , 
	N'' ,
	'may-hut-bui-khong-day-panasonic-s48' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	6 , 4
) ,

-- https://www.dienmayxanh.com/may-hut-bui/samsung-vcc8835v37-xsv
( 
	49 , 
	N'Máy hút bụi dạng hộp Samsung S49' ,
	100 , 13 , 3290000 , 
	N'' ,
	'may-hut-bui-dang-hop-samsung-s49' ,
	'1.jpg' , '2.jpg' , '' , '' , '' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/may-hut-bui/panasonic-mc-cg371an46
( 
	64 , 
	N'Máy hút bụi dạng hộp Panasonic S64' ,
	100 , 29 , 4050000 , 
	N'' ,
	'may-hut-bui-dang-hop-panasonic-s64' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	6 , 4
) ,

-- https://www.dienmayxanh.com/robot-hut-bui/samsung-vr05r5050wk-sv
( 
	65 , 
	N'Robot hút bụi lau nhà Samsung S65' ,
	100 , 25 , 1960000 , 
	N'' ,
	'robot-hut-bui-lau-nha-samsung-s65' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/robot-hut-bui/samsung-vr05r5050wk-sv
( 
	68 , 
	N'Máy hút bụi không dây Samsung S68' ,
	100 , 5 , 25990000 , 
	N'' ,
	'may-hut-bui-khong-day-samsung-s68' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	6 , 5
) ,


-- Lọc nước
-- https://www.dienmayxanh.com/may-loc-nuoc/kangaroo-kg99a-vtu-kg
( 
	50 , 
	N'Máy lọc nước RO Kangaroo VTU 9 lõi S50' ,
	100 , 32 , 6690000 , 
	N'' ,
	'may-loc-nuoc-ro-kangaroo-vtu-9-loi-s50' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-ro-sunhouse-sha8889k-9-loi-kg
( 
	51 , 
	N'Máy lọc nước RO Sunhouse 9 lõi S51' ,
	100 , 30 , 7490000 , 
	N'' ,
	'may-loc-nuoc-ro-sunhouse-9-loi-s51' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 8
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/kangaroo-kg10a3
( 
	52 , 
	N'Máy lọc nước RO nóng nguội lạnh Kangaroo 10 lõi S52' ,
	100 , 27 , 9900000 , 
	N'' ,
	'may-loc-nuoc-ro-kangaroo-10-loi-s52' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '5.jpg' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-ro-khong-vo-kangaroo-kg110-9-loi-kg
( 
	53 , 
	N'Máy lọc nước RO không vỏ Kangaroo 9 lõi S53' ,
	100 , 5 , 6990000 , 
	N'' ,
	'may-loc-nuoc-ro-khong-vo-kangaroo-9-loi-s53' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-nong-lanh-ro-korihome-wpk-903
( 
	54 , 
	N'Máy lọc nước RO nóng lạnh Korihome 7 lõi S54' ,
	100 , 16 , 13340000 , 
	N'' ,
	'may-loc-nuoc-ro-korihome-7-loi-s54' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 10
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/ion-kiem-panasonic-tk-as45-3-tam-dien-cuc
( 
	55 , 
	N'Máy lọc nước ion kiềm Panasonic 3 tấm điện cực S55' ,
	100 , 0 , 25500000 , 
	N'' ,
	'may-loc-nuoc-ion-kiem-panasonic-3-tam-dien-cuc-s55' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 4
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/ion-kiem-panasonic-tk-ab50-5-tam-dien-cuc
( 
	66 , 
	N'Máy lọc nước ion kiềm Panasonic 5 tấm điện cực S66' ,
	100 , 0 , 53500000 , 
	N'' ,
	'may-loc-nuoc-ion-kiem-panasonic-5-tam-dien-cuc-s66' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 4
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-ro-kangaroo-kg100hu
( 
	67 , 
	N'Máy lọc nước R.O Hydrogen Kangaroo 5 lõi S67' ,
	100 , 23 , 9490000 ,
	N'' ,
	'may-loc-nuoc-r.o-hydrogen-kangaroo-5-loi-s67' ,
	'1.jpg' , '2.jpg' , '3.jpg' , '4.jpg' , '' ,
	7 , 2
)
SET IDENTITY_INSERT products OFF
go

-- update product viewCount
update products set viewCount = 157 where id = 1
update products set viewCount = 150 where id = 2
update products set viewCount = 142 where id = 3
update products set viewCount = 139 where id = 4
update products set viewCount = 195 where id = 5
update products set viewCount = 175 where id = 6
update products set viewCount = 171 where id = 7
update products set viewCount = 177 where id = 8
update products set viewCount = 122 where id = 9
update products set viewCount = 195 where id = 10
update products set viewCount = 84 where id = 11
update products set viewCount = 190 where id = 12
update products set viewCount = 117 where id = 13
update products set viewCount = 152 where id = 14
update products set viewCount = 99 where id = 15
update products set viewCount = 188 where id = 16
update products set viewCount = 199 where id = 17
update products set viewCount = 56 where id = 18
update products set viewCount = 140 where id = 19
update products set viewCount = 174 where id = 20
update products set viewCount = 80 where id = 21
update products set viewCount = 91 where id = 22
update products set viewCount = 188 where id = 23
update products set viewCount = 174 where id = 24
update products set viewCount = 110 where id = 25
update products set viewCount = 93 where id = 26
update products set viewCount = 84 where id = 27
update products set viewCount = 184 where id = 28
update products set viewCount = 115 where id = 29
update products set viewCount = 169 where id = 30
update products set viewCount = 139 where id = 31
update products set viewCount = 144 where id = 32
update products set viewCount = 165 where id = 33
update products set viewCount = 146 where id = 34
update products set viewCount = 183 where id = 35
update products set viewCount = 64 where id = 36
update products set viewCount = 60 where id = 37
update products set viewCount = 120 where id = 38
update products set viewCount = 141 where id = 39
update products set viewCount = 136 where id = 40
update products set viewCount = 104 where id = 41
update products set viewCount = 71 where id = 42
update products set viewCount = 188 where id = 43
update products set viewCount = 122 where id = 44
update products set viewCount = 181 where id = 45
update products set viewCount = 198 where id = 46
update products set viewCount = 192 where id = 47
update products set viewCount = 114 where id = 48
update products set viewCount = 122 where id = 49
update products set viewCount = 175 where id = 50
update products set viewCount = 97 where id = 51
update products set viewCount = 137 where id = 52
update products set viewCount = 123 where id = 53
update products set viewCount = 103 where id = 54
update products set viewCount = 74 where id = 55
update products set viewCount = 105 where id = 56
update products set viewCount = 67 where id = 57
update products set viewCount = 140 where id = 58
update products set viewCount = 55 where id = 59
update products set viewCount = 188 where id = 60
update products set viewCount = 137 where id = 61
update products set viewCount = 174 where id = 62
update products set viewCount = 118 where id = 63
update products set viewCount = 195 where id = 64
update products set viewCount = 94 where id = 65
update products set viewCount = 199 where id = 66
update products set viewCount = 197 where id = 67
update products set viewCount = 86 where id = 68
go

-- update product description
update products set [description] =N'
	<h5>Nồi cơm điện Kangaroo kiểu dáng mềm mại, hiện đại, trẻ trung bắt mắt mới 2 màu đỏ và trắng, tạo điểm nhấn cho gian bếp gia đình</h5>
	<h5>Dung tích nồi 1.8 lít phục vụ tốt cho các gia đình 4 – 6 người ăn</h5>
	<h5>Nồi cơm nắp gài dễ sử dụng với hệ nút nhấn điện tử có màn hình hiển thị, đa chức năng nấu tùy chọn theo nhu cầu</h5>
	<p>
	Nồi có thể nấu cơm, nấu súp, làm bánh, hầm, nấu cháo, nấu thịt gà và giữ ấm, rất tiện lợi cho các bữa ăn gia đình.
	<br>
	Nấu cơm chín nhanh với thời gian mặc định 30 phút và tối thiểu 20 phút là bạn đã có bữa cơm ngon cùng với gia đình của mình.
	</p>
	<h5>Lòng nồi 2 lớp phủ hợp kim nhôm tráng men chống dính, dày 2 mm, bền bỉ, chống dính cháy, cho cơm chín ngon, dễ lau chùi sau khi dùng</h5>
	<h5>Mâm nhiệt đáy nồi bằng chất liệu nhôm nguyên chất gia nhiệt nhanh, nấu cơm chín mau, tiết kiệm thời gian và điện năng tiêu thụ</h5>
	<h5>Công nghệ ủ ấm 3D giúp nồi giữ ấm cơm lâu, cơm ngon ấm nóng sẵn sàng phục vụ gia đình trong nhiều giờ</h5>
	<h5>Kèm thêm xửng hấp cho người dùng chế biến các món hấp đơn giản như rau củ, nấu xôi, làm bánh, ...</h5>
	<p>
	Nồi cơm điện nắp gài Kangaroo S1 1.8L sản phẩm đẹp, dễ dùng, dùng bền, phục vụ tốt cho từng bữa ăn gia đình.
	</p>
' where id = 1
go

update products set [description] =N'
	<h5>Nồi cơm nắp gài Kangaroo kiểu dáng đơn giản, họa tiết hoa Hàn Quốc trên thân nồi đẹp mắt</h5>
	<p>
	Thiết kế nổi bật trên nền đỏ - trắng chủ đạo cho tổng thể thiết kế hiện đại, có tính thẩm mỹ cao. Dung tích 1.8 lít đáp ứng nhu cầu nấu cơm cho gia đình có từ 4 - 6 thành viên.
	</p>
	<h5>Lòng nồi dày 1.001 mm bằng hợp kim nhôm phủ chống dính bền bỉ, an toàn khi dùng, hạn chế cơm dính cháy, dễ lau chùi</h5>
	<h5>Cơm chín nhanh chóng khoảng 20 - 30 phút với công suất mạnh mẽ 700W, công nghệ nấu 1D</h5>
	<p>
	Trong nồi có trang bị 1 mâm nhiệt phẳng truyền nhiệt rộng, cho hiệu suất nấu cao.
	</p>
	<h5>Điều khiển nút gạt tùy chỉnh chức năng nấu - giữ ấm dễ sử dụng</h5>
	<p>
	Chế độ giữ ấm 3D của nồi cơm điện giúp cơm chín đều, thơm ngon hơn.
	</p>
	<h5>Kiểm soát hơi nước, cho cơm bổ dưỡng, hạn chế nhão với van thoát hơi, khay hứng nước thừa và nắp trong dạng tổ ong</h5>
	<h5>Có xửng hấp đi kèm nồi cơm điện Kangaroo cho bạn hấp bánh bao, rau củ,... thuận tiện</h5>
	<h5>Lưu ý:</h5>
	<p>
	- Không vo gạo trực tiếp trong lòng nồi để hạn chế làm trầy lớp chống dính.
	<br>
	- Khi đang nấu cơm, không nên dùng khăn hoặc vật dụng để chặn van thoát hơi.
	<br>
	- Chùi rửa nồi sạch sẽ sau mỗi lần nấu để tránh ám mùi cho lần nấu tiếp theo.
	<br><br>
	Nồi cơm nắp gài Kangaroo S2 1.8 lít, sản phẩm của thương hiệu nổi tiếng Kangaroo - Việt Nam, sản xuất tại Trung Quốc, kết cấu gọn đẹp, màu sắc nổi bật, nấu cơm chín ngon, hứa hẹn sẽ là trợ thủ phòng bếp đắc lực cho bạn.
	</p>
' where id = 2
go

update products set [description] =N'
	<h5>Nồi cơm điện Sunhouse có màu trắng hồng nhẹ nhàng, xinh xắn, phù hợp với thị hiếu của nữ giới</h5>
	<p>
	Thân nồi cơm điện dày, kiểu nồi cơm nắp gài cho nồi giữ nhiệt tốt, cơm nóng ngon lâu.
	</p>
	<h5>Nấu đủ cơm cho gia đình có 4 - 6 thành viên với dung tích 1.8 lít</h5>
	<h5>Nút gạt thiết kế ở mặt trước thân nồi cho bạn chỉnh chức năng nấu và giữ ấm dễ dàng, linh hoạt</h5>
	<h5>Lòng nồi 2 lớp dày 1.207 mm làm bằng hợp kim nhôm phủ lớp chống dính Whitford - USA, an toàn cho sức khỏe, nấu cơm chín ngon, tơi, hấp dẫn, làm sạch, vệ sinh đơn giản</h5>
	<h5>Nấu cơm chín nhanh với công nghệ nấu 1D, công suất 700W, tiết kiệm điện năng của gia đình</h5>
	<p>
	Nồi có chế độ ủ ấm 3D cho khả năng giữ ấm cơm lâu đến 24 tiếng.
	<br>
	Chỉ tiêu tốn khoảng 20 - 25 phút bạn đã có cơm nóng, thơm ngon để thưởng thức cùng gia đình.
	</p>
	<h5>Hấp thức ăn đơn giản, thuận tiện với xửng hấp được tặng kèm nồi</h5>
	<p>
	Nồi cơm nắp gài Sunhouse S3 1.8 lít thiết kế đẹp, dùng nấu cơm nhanh, giá cả phải chăng, xứng đáng có mặt trong mọi gia đình.
	</p>
' where id = 3
go

update products set [description] =N'
	<h5>Nồi cơm nắp gài Toshiba 1.8 lít thiết kế hiện đại, màu sắc trẻ trung phù hợp mọi căn bếp</h5>
	<h5>Dung tích nồi cơm điện 1.8 lít đáp ứng tốt nhu cầu nấu cơm cho gia đình có từ 4 - 6 người</h5>
	<h5>Nút gạt thiết kế ở mặt trước thân nồi cho bạn chỉnh chức năng nấu và giữ ấm dễ dàng, linh hoạt</h5>
	<p>
	Giữ ấm tự động lên đến 6 tiếng.
	</p>
	<h5>Công nghệ 1D (toả nhiệt từ 1 hướng) với công suất lớn 650 W giúp truyền nhiệt nhanh, cơm chín mau, ít tốn điện</h5>
	<p>
	Nấu cơm nhanh chín chỉ sau 25 – 30 phút, tiết kiệm điện hiệu quả.
	</p>
	<h5>Lòng nồi cơm điện Toshiba 2 lớp bằng hợp kim nhôm phủ lớp chống dính, dày 1 mm, an toàn với sức khoẻ và vệ sinh đơn giản</h5>
	<p>
	Đảm bảo cơm chín tơi, ngon, không dính vào thành, đáy nồi, tiện chùi rửa.
	</p>
	<h5>Nắp trong của nồi thiết kế dạng tổ ong giúp giữ lại hơi nước, không để nó rơi ngược vào cơm gây nhão, thiu</h5>
	<h5>Hấp thức ăn đơn giản, thuận tiện với xửng hấp được tặng kèm nồi</h5>
	<p>
	Nồi cơm nắp gài Toshiba S4 1.8 lít thiết kế trang nhã, tiện dụng, nấu cơm ngon, là lựa chọn tuyệt hảo cho gia đình Việt.
	</p>
' where id = 4
go

update products set [description] =N'
	<h5>Nồi cơm điện Sharp 1.5 lít có thân nồi màu trắng đỏ nổi bật, nắp bằng thép không gỉ</h5>
	<h5>Dung tích nồi cơm nắp rời 1.5 lít, có thể dùng nấu cơm cho gia đình từ 2 - 4 người</h5>
	<h5>Chế độ nấu và giữ ấm dễ dàng tùy chỉnh với nút gạt, thời gian giữ ấm của nồi lâu đến 5 giờ</h5>
	<p>
	Nồi sau khi nấu cơm xong sẽ tự động chuyển sang chế độ giữ ấm và giữ cho cơm nóng ngon trong thời gian dài, đảm bảo bạn có cơm nóng hổi thưởng thức mọi lúc.
	</p>
	<h5>Công nghệ nấu 1D cùng công suất 530W giúp nấu cơm chín nhanh, ít hao điện</h5>
	<h5>Lòng nồi 1 lớp dày 1 mm bằng nhôm dày bền, an toàn cho sức khỏe, dễ vệ sinh</h5>
	<h5>Tay cầm và chân đế bọc nhựa Phenolic cách nhiệt tốt, không sợ nóng, bỏng tay khi di chuyển</h5>
	<h5>Dây điện tháo rời, thuận tiện cho việc di chuyển và cất giữ nồi</h5>
	<p>
	Nồi cơm nắp rời Sharp S5 1.5 lít sử dụng bền lâu, an toàn, phù hợp với nhu cầu nấu cơm cơ bản của mọi gia đình.
	</p>
' where id = 5
go

update products set [description] =N'
	<h5>Nồi cơm điện Sunhouse thiết kế đẹp mắt, màu sắc hài hoà, ấm cúng</h5>
	<h5>Dung tích nồi 2.2 lít đáp ứng đủ nhu cầu nấu cơm cho cả gia đình từ 6 thành viên trở lên</h5>
	<h5>Bảng điều khiển nút gạt 1 thao tác, đơn giản dễ sử dụng</h5>
	<h5>Lòng nồi cơm điện dày 0,8 mm làm bằng hợp kim nhôm dày bền, chống móp méo tốt, giữ nhiệt hiệu quả, nấu an toàn, cơm chín ngon</h5>
	<p>
	Chỉ tiêu tốn khoảng 20 - 25 phút bạn đã có cơm nóng hổi, thơm ngon để thưởng thức cùng gia đình.
	</p>
	<h5>Nồi cơm điện nấu cơm nhanh với công nghệ 1D với công suất 900W, tiết kiệm thời gian và điện năng, giữ ấm được 4 tiếng</h5>
	<h5>Nồi với xửng hấp lớn tiện lợi, giúp bạn hấp bánh bao, rau củ dễ dàng</h5>
	<p>
	<b>Lưu ý khi sử dụng nồi cơm điện:</b><br>
	- Không vo gạo trong nồi, nên vo gạo bằng rổ sau đó cho vào lòng nồi.
	<br>
	- Lau khô lòng nồi trước khi nấu.
	<br>
	- Hạn chế cắm dây điện của nồi cơm chung ổ cắm với các thiết bị khác có công suất cao.
	<br>
	- Không bít lỗ thoát hơi.
	<br>
	- Không chà nồi bằng miếng kim loại.
	<br>
	<br>
	Nồi cơm nắp rời Sunhouse S6 2.2 lít thương hiệu uy tín, chất lượng, nấu cơm ngon được nhiều người tin dùng. 
	</p>
' where id = 6
go

update products set [description] =N'
	<h5>Nồi cơm điện tử áp suất Cuckoo 1.8 lít với lớp vỏ màu trắng trang nhã, thiết kế hiện đại tạo sự độc đáo trong không gian sống</h5>
	<p>
	Nồi cơm điện tử áp suất Cuckoo mang đặc điểm của cả 2 dạng nồi điện tử và áp suất, giúp giữ kín lượng hơi nước, hạn chế hơi nước thoát ra trong quá trình nấu, khiến áp suất trong nồi tăng cao, làm thức ăn chín mềm hơn.
	<br>
	Sử dụng hệ thống cung cấp nhiệt ở đáy, xung quanh thân nồi và trên nắp nồi nên nồi cơm điện tử áp suất cho cơm chín đều, thơm ngon và bảo toàn dinh dưỡng hơn.
	<br>
	Nồi cơm Cuckoo với màu trắng ngà trang nhã, quý phái, giúp tăng tính thẩm mỹ cho không gian bếp.
	<h5>Dung tích 1.8 lít dùng nấu cơm phù hợp cho gia đình 4 – 6 thành viên</h5>
	<p>
	Nấu được 8 - 10 cốc gạo đi kèm nồi.
	</p>
	<h5>Nồi cơm điện Cuckoo trang bị lòng nồi phủ men X-Wall Marble cao cấp độc quyền của Cuckoo</h5>
	<p>
	Độ dày lòng nồi 3.183 mm, bền bỉ, nấu cơm an toàn, không dính cháy, chống trầy xước, dễ dàng vệ sinh. Có tay cầm 2 bên thành nồi tiện lợi, tránh bỏng nóng khi sử dụng.
	</p>
	<h5>Nồi cơm điện tử áp suất sử dụng thuận tiện qua bảng điều khiển nút nhấn điện tử dễ thao tác</h5>
	<p>
	Nồi có chức năng hẹn giờ đến 12 tiếng 50 phút, hỗ trợ bạn nấu nướng linh hoạt thời gian.
	</p>
	<h5>Sở hữu 12 chương trình cài sẵn tiện lợi:</h5>
	<p>
	Gồm chức năng: cháo đặc, cơm cháy, gạo trộn, giữ ấm, gạo lứt, gạo lứt nảy mầm Gaba, gạo nếp, nấu cơm, nấu nhanh, nấu nhiệt độ cao, nấu đa năng, tự động làm sạch hỗ trợ tích cực cho người nội trợ, đơn giản hóa việc chuẩn bị những bữa ăn ngon giàu dinh dưỡng cho gia đình.
	<br>
	<b>Lưu ý:</b> Hãng khuyến cáo nên điều chỉnh chức năng giữ ấm tối đa 24 tiếng (và còn tùy vào khí hậu, loại gạo,...) để đảm bảo vẫn giữ được chất lượng cơm nấu ra.
	</p>
	<h5>Nồi nấu cơm chín đều thơm ngon, giữ lại tối đa dưỡng chất trong gạo nhờ công nghệ nấu 3D</h5>
	<h5>Van thoát hơi thông minh kiểm soát lượng hơi nước thoát ra, giữ lại nhiều dưỡng chất và vitamin trong gạo</h5>
	<p>
	Khay hứng nước thừa giữ vệ sinh, tránh văng nước ra ngoài khi sử dụng.
	</p>
	<h5>Dây điện của nồi dài 126 cm giúp người dùng có thể sử dụng nồi ở nơi xa nguồn điện</h5>
	<p>
	<b>Để sử dụng nồi cơm điện bền tốt:</b>
	<p>
	- Kiểm tra ổ cắm, dây điện có bị hở, rò rỉ điện khi kết nối với nồi, tránh hiện tượng chập điện.
	<br>
	- Sử dụng muỗng lấy cơm bằng nhựa, silicone hoặc gỗ để tránh làm trầy xước mặt chống dính.
	<br>
	- Không vệ sinh khi lòng nồi còn nóng.
	<br>
	<br>
	- Làm sạch lòng nồi, vỏ nồi, nắp trong, khay hứng nước để nồi cơm đảm bảo sạch sẽ, vệ sinh, an toàn khi nấu, tránh gây ám mùi.
	Nồi cơm điện tử áp suất Cuckoo S7 1.8 lít nhập khẩu trực tiếp từ Hàn Quốc, hiện đại, đa chức năng tiện dụng, nấu ngon, an toàn, lựa chọn hữu ích cho gian bếp gia đình.
	</p>
' where id = 7
go

update products set [description] =N'
	<p>
	<b>Nồi cơm điện tử áp suất Mishio 1 lít là sản phẩm nồi cơm kết hợp nồi nấu áp suất, hẹn giờ và giữ ấm đến 24 tiếng, đa dạng chương trình cài đặt sẵn,... hỗ trợ bạn chế biến nhiều món ăn bổ dưỡng cho gia đình.</b>
	</p>
	<h5>Công nghệ nấu, công suất - Dung tích</h5>
	<p>
	Công suất 600W kết hợp công nghệ nấu 1D giúp nồi nấu thức ăn chín nhanh, tiết kiệm điện năng.
	<br>
	Dung tích 1 lít nhỏ gọn, nấu được 5 - 8 cốc gạo kèm nồi, đáp ứng tốt khẩu phần ăn cho 2 - 4 người.
	</p>
	<h5>Bảng điều khiển - Chương trình cài đặt sẵn</h5>
	<p>
	- Bảng điều khiển cảm ứng hiện đại, có màn hình hiển thị, dễ quan sát và điều chỉnh các chức năng.
	<br>
	- 11 chương trình cài đặt sẵn giúp bạn nấu đa dạng món ngon: cháo, giữ ấm, hâm nóng, hạt ngũ cốc, hầm nhanh, nấu bò, nấu cơm, nấu gà, nấu đậu/gân, súp, đồ ăn trẻ em.
	</p>
	<h5>Thiết kế của sản phẩm</h5>
	<p>
	- Mẫu nồi cơm điện Mishio này được thiết kế nhỏ gọn, màu đen trung tính và hiện đại, dễ di chuyển và đặt gọn trên bàn ăn.
	<br>
	- Vỏ ngoài bằng nhựa PP bền tốt, dễ lau chùi sau khi sử dụng.
	<br>
	- Lòng nồi hợp kim nhôm phủ chống dính, gia nhiệt tốt giúp cơm chín đều, thơm ngon, chống dính cháy và tiện vệ sinh.
	</p>
	<h5>Tiện ích - Phụ kiện</h5>
	<p>
	- Hẹn giờ và giữ ấm cơm đến 24 tiếng, giúp gia đình luôn có cơm nóng để thưởng thức khi cần.
	<br>
	- Trang bị tính năng tự động xả áp khi áp suất trong nồi đạt giới hạn và chỉ có thể mở nắp khi áp suất trong nồi đã hết, để bạn nấu nướng an toàn, tiện lợi hơn.
	<br>
	- Phụ kiện đi kèm nồi cơm điện: cốc đong, muỗng cơm.
	<br>
	<br>
	Nồi cơm điện tử áp suất Mishio S8 1 lít sở hữu tính năng nấu áp suất, nhiều chương trình cài sẵn tiện lợi, dễ sử dụng, thích hợp cho những bà nội trợ bận rộn, mang đến cho gia đình những món ăn nóng hổi, giàu dinh dưỡng.
	</p>
' where id = 8
go

update products set [description] =N'
	<h5>Nồi cơm điện cao tần Kangaroo có vỏ ngoài bằng thép không gỉ sáng bóng, kết cấu bền chắc</h5>
	<p>
	Sử dụng bền lâu, tăng tính thẩm mỹ cho mọi gian bếp.
	</p>
	<h5>Dung tích 1.8 lít, nồi cơm điện đáp ứng nhu cầu nấu cơm trong gia đình có từ 4 – 6 thành viên</h5>
	<h5>Bảng điều khiển điện tử hướng dẫn tiếng Việt, màn hình hiển thị rõ ràng giúp bạn tùy chỉnh các chức năng, chế độ nấu linh hoạt, chính xác</h5>
	<p>
	Có các chế độ nấu tự động đa dạng gồm nấu cơm tiêu chuẩn, nấu chậm, nấu nhanh, cơm niêu, nấu súp, nấu cháo nguyên hạt, cháo nhừ, làm bánh, hấp, hâm nóng, giữ ấm,... giúp bạn nấu ăn thuận tiện, đa dạng bữa cơm cho gia đình.
	<br>
	Ngoài ra, bạn có thể chọn chế độ nấu cho từng loại gạo giúp bạn nấu cơm ngon, bổ dưỡng hơn.
	<br>
	Nồi còn có chức năng hẹn giờ nấu đến 24 tiếng, giúp bạn chủ động thời gian nấu nướng.
	</p>
	<h5>Công suất 1200 W, sử dụng công nghệ cao tần giúp cơm được nấu chín đều, thơm ngon, tơi xốp hơn</h5>
	<h5>Lòng nồi bằng hợp kim nhôm có 7 lớp, độ dày 2 mm siêu bền, an toàn khi nấu</h5>
	<p>
	Cơm chín tơi, ngon, không bám dính vào thành và đáy nồi, không có cơm cháy, dễ làm sạch.
	<br>
	Ngoài ra, lòng nồi dày giúp giữ ấm cơm lâu hơn mà ít tốn điện hơn.
	</p>
	<h5>Nắp trong của nồi dạng tổ ong ngăn nước rơi ngược vào cơm, chống nhão, thiu hiệu quả</h5>
	<p>
	Hơn thế, phía dưới nắp nồi cơm điện cao tần có điện trở sưởi giúp giữ ấm cơm đến 24 tiếng mà cơm không bị hư, thiu như những nồi cơm thông thường khác; khi nấu cơm chín, sẽ có một ít lượng hơi nước chảy dọc ra xung quanh vành ngoài lòng nồi.
	</p>
	<h5>Quai xách cho phép bạn di chuyển nồi đến mọi địa điểm nhanh gọn, an toàn</h5>
	<p>
	Nồi cơm điện cao tần Kangaroo S9 thiết kế đẹp, nhiều tính năng, nấu ăn ngon, hiệu quả, xứng đáng có mặt trong gia đình Việt.
	</p>
' where id = 9
go

update products set [description] =N'
	<h5>Nồi cơm điện cao tần Toshiba thiết kế sang trọng, thân nồi dày, giữ nhiệt lâu</h5>
	<h5>Dung tích 1.8 lít nồi đáp ứng nhu cầu sử dụng của gia đình có từ 4 – 6 thành viên</h5>
	<h5>Bảng điều khiển điện tử với nhiều nút nhấn rõ ràng cho phép bạn tùy chỉnh các chức năng chính xác, dễ dàng</h5>
	<h5>Chức năng nấu tự động đa dạng, hẹn giờ tiện dụng</h5>
	<p>
	Bạn có thể nấu cơm trắng thường, cơm mềm, cơm khô, nấu cơm trộn, gạo lứt, làm bánh, hấp, nấu cháo, luộc trứng,… thêm chức năng giữ ấm 24 tiếng, hâm nóng giúp bạn chuẩn bị bữa cơm gia đình đa dạng chỉ với 1 nồi cơm điện tử cao tần.
	<br>
	Chức năng hẹn giờ nấu xong cho phép bạn tùy chọn thời gian nấu phù hợp với từng món ăn tiện lợi, giúp bạn chế biến món ăn ngon, đúng thời gian hơn.
	<br>
	<b>Lưu ý:</b> Hãng khuyến cáo chức năng hẹn giờ nên cài đặt 12 - 24 tiếng (và còn tùy thuộc vào khí hậu, loại gạo,...) để giữ được vị ngon và dinh dưỡng trong gạo.
	</p>
	<h5>Lòng nồi 3 lớp dày 1.7 mm bằng chất liệu hợp kim nhôm phủ lớp chống dính Diamond Titanium dày chắc, bền bỉ</h5>
	<p>
	An toàn khi nấu, hạt cơm chín tơi, xốp, không có cơm cháy, dễ chùi rửa bên trong lòng nồi.
	</p>
	<h5>Sử dụng công nghệ nấu cao tần (IH) chỉnh chính xác nhiệt độ nấu</h5>
	<p>
	Công nghệ nấu cao tần cho phép làm nóng trực tiếp lòng nồi mà không cần thông qua mâm nhiệt, cơ chế tương tự như bếp từ, điều này giúp cho cơm ngon và bảo toàn chất dinh dưỡng nhiều hơn so với các nồi cơm sử dụng mâm nhiệt truyền thống.
	</p>
	<h5>Van thoát hơi chống tràn, bảo toàn lượng dưỡng chất và vitamin có sẵn trong gạo</h5>
	<h5>Xửng hấp thiết kế gọn đẹp giúp bạn hấp rau củ, bánh bao thuận tiện hơn</h5>
	<p>
	Nồi cơm điện cao tần Toshiba S10 nhiều chức năng, nấu ăn ngon, đa dạng, thích hợp sử dụng trong gia đình, nhà hàng, khách sạn, ...
	</p>
' where id = 10
go

update products set [description] =N'
	<h5>Nồi cơm điện Panasonic thiết kế đẹp mắt, màu sắc trang nhã, phù hợp với mọi không gian nhà bếp</h5>
	<h5>Lòng nồi cơm điện 6 lớp, dày tới 4 mm, bên trong phủ lớp chống dính màu đen, bên ngoài phủ Almite và sơn đen, cho khả năng giữ ấm lâu, dễ vệ sinh</h5>
	<h5>Nồi có dung tích 1.8 lít phù hợp nấu cơm cho 4 - 6 người ăn</h5>
	<h5>Nồi cơm dùng công nghệ nấu 3D, giúp cơm nấu mau chín, hạn chế cơm nhão, tiết kiệm thời gian</h5>
	<p>
	Nồi có khả năng giữ ấm đến 12 tiếng, hẹn giờ nấu đến 24 tiếng, hỗ trợ bạn nấu nướng linh hoạt thời gian.
	</p>
	<h5>Menu nấu tự động của nồi gồm 14 chế độ, đáp ứng đủ mọi nhu cầu nấu ăn của gia đình bạn</h5>
	<p>
	Các chế độ cài đặt sẵn: nấu cơm thông thường, cơm dẻo, cơm khô, nấu nhanh/nấu hạt diêm mạch, gạo lứt, nấu ngũ cốc (hạt hỗn hợp), gạo thơm hoa nhài (gạo Jasmine), gạo nếp, nấu cháo, cơm niêu, súp/nấu chậm, làm bánh/bánh mì, hấp và giữ ấm, hỗ trợ bạn nấu nướng thuận tiện hơn.
	</p>
	<h5>Nồi còn được tặng kèm xửng hấp cao cấp, giúp hấp bánh bao, hấp rau củ quả,...</h5>
	<p>
	Dây điện nồi cơm có thể tháo rời dễ dàng bảo quản.
	</p>
	<p>
	<b>Lưu ý khi sử dụng nồi cơm điện:</b>
	<br>
	- Không vo gạo trong nồi.
	<br>
	- Lau khô lòng nồi trước khi nấu.
	<br>
	- Hạn chế cắm dây điện của nồi cơm chung ổ cắm với các thiết bị khác có công suất cao.
	<br>
	- Không bít lỗ thoát hơi.
	<br>
	- Không dùng miếng nhám chà nồi, đồ chà nồi có chứa kim loại.
	<br><br>
	Nồi cơm điện tử Panasonic S11 1.8 lít thương hiệu Nhật Bản, nhiều chức năng nấu tiện dụng, được nhiều người tin dùng. 
	</p>
' where id = 11
go

update products set [description] =N'
	<h5>Nồi cơm điện sở hữu 6 chức năng nấu cài đặt sẵn hỗ trợ tối đa nhu cầu nấu nướng của chị em nội trợ</h5>
	<p>
	Đơn giản hóa việc chuẩn bị những bữa ăn ngon giàu dinh dưỡng cho gia đình với những chức năng: giữ ấm, hấp/luộc, nấu súp, nấu cháo, cơm niêu, nấu cơm thường.
	</p>
	<h5>Nồi cơm điện tử dễ dàng quan sát và thao tác điều chỉnh</h5>
	<p>
	Tùy chỉnh các chức năng tùy ý chỉ bằng vài thao tác chạm nhẹ trên bảng điều khiển cảm ứng có màn hình hiển thị.
	<br>
	Nồi còn có tính năng hẹn giờ nấu đến 24 tiếng vô cùng tiện lợi. Bên cạnh đó, hãng cũng khuyến cáo người dùng nên giữ ấm cơm tối đa 12 tiếng (tùy chất lượng gạo, khí hậu,...) để giữ được độ mềm ngon của cơm.
	</p>
	<h5>Vận hành với công suất 600W cùng công nghệ nấu 2D có nhiệt lượng tỏa đều xung quanh thân và đáy nồi cho cơm chín đều, nhanh chóng</h5>
	<h5>Lòng nồi dạng niêu, dày 1.713 mm bằng hợp kim nhôm phủ chống dính Daikin hạn chế cháy dính, méo móp do va chạm và giữ ấm lâu</h5>
	<h5>Dung tích 1.2 lít có thể nấu được 5 - 8 cốc gạo đi kèm nồi</h5>
	<h5>Nồi cơm điện Hommy sở hữu vẻ ngoài sang trọng với màu đen huyền bí, mang lại nét hiện đại cho không gian bếp nhà bạn</h5>
	<p>
	Nồi có tay cầm 2 bên giúp di chuyển dễ dàng, chắc chắn, không lo rơi rớt.
	</p>
	<h5>Dây điện có thể tháo rời, cất gọn dễ dàng, bảo đảm an toàn khi di chuyển nồi</h5>
	<h5>Đi kèm vá múc cơm, xửng hấp, cốc đong giúp đơn giản hoá các bước nội trợ trong gia đình</h5>
	<p>
	Nồi cơm điện tử Hommy S12 1.2 lít đa dạng chức năng nấu, thao tác đơn giản, tiện quan sát với bảng điều khiển cảm ứng có đèn LED hỗ trợ tối đa chị em nội trợ chuẩn bị những bữa cơm ngon cho gia đình.
	</p>
' where id = 12
go

update products set [description] =N'
	<h5>Vỏ ngoài bằng nhựa cao cấp cùng dung tích 1.8 lít phù hợp với gia đình có 4 - 6 thành viên</h5>
	<h5>Nắp nồi thiết kế dạng tổ ong, ngăn không cho nước rơi xuống làm cơm bị nhão và nhanh thiu</h5>
	<h5>Lòng nồi cơm bằng hợp kim nhôm phủ chống dính dễ làm sạch</h5>
	<p>
	Lòng nồi cơm điện Sharp 2 lớp dày 1 mm được làm bằng chất liệu hợp kim nhôm phủ chống dính giúp cho nấu cơm không dính vào thành và đáy nồi, thuận tiện khi vệ sinh. 
	</p>
	<h5>Nồi nấu cơm chín nhanh, tiết kiệm năng lượng nhưng vẫn đảm bảo sự thơm ngon với công nghệ nấu 1D</h5>
	<h5>Van thoát hơi thông minh kiểm soát lượng hơi nước thoát ra, giữ lại nhiều dưỡng chất và vitamin trong gạo</h5>
	<h5>Nồi cơm kèm xửng hấp cao cấp, có thể hấp rau củ, bánh bao</h5>
	<p>
	Nồi cơm nắp gài Sharp S13 1.8 lít thương hiệu Nhật Bản nổi tiếng, chất lượng cao, giá cả phải chăng phù hợp túi tiền đại đa số người dùng.
	</p>
' where id = 13
go

update products set [description] =N'
	<h5>Nồi cơm nắp gài Sunhouse 1 lít kiểu dáng nhỏ gọn, thanh lịch, màu sắc tươi sáng</h5>
	<p>
	Dung tích nồi cơm điện 1 lít đáp ứng đủ nhu cầu nấu cơm cho gia đình từ 2 - 4 người. 
	</p>
	<h5>Bảng điều khiển nút gạt với 2 chức năng Cook (nấu)/ Warm (giữ ấm) đơn giản, dễ dùng</h5>
	<h5>Lòng nồi cơm điện Sunhouse 2 lớp dày 1.35 mm bằng hợp kim nhôm phủ lớp chống dính Whitford an toàn cho sức khoẻ, tiện vệ sinh</h5>
	<p>
	Chỉ tiêu tốn khoảng 18 - 20 phút bạn đã có cơm nóng hổi, thơm ngon để thưởng thức cùng gia đình.
	</p>
	<h5>Nồi nấu cơm với công nghệ nấu 1D giúp cơm mau chín, tiết kiệm thời gian</h5>
	<h5>Mở nắp nồi cơm điện bằng nút nhấn hiện đại thao tác nhẹ nhàng</h5>
	<h5>Van thoát hơi nước thông minh giúp giữ lại vitamin, dưỡng chất có trong gạo khi nấu</h5>
	<h5>Dây điện có thể tháo rời tiện bảo quản, cất giữ</h5>
	<p>
	Nồi cơm nắp gài Sunhouse S14 1 lít thương hiệu uy tín, chất lượng được nhiều người tin dùng.
	</p>
' where id = 14
go

update products set [description] =N'
	<p>
	<b>Bếp từ Crystal có công suất 2000W khi gia nhiệt nhanh, mặt bếp bằng kính Ceramic - Kanger (Trung Quốc) chịu nhiệt tốt, dễ lau chùi, nhiều tiện ích và tính năng an toàn đi kèm như hẹn giờ, chức năng Booster nấu nhanh, khóa bảng điều khiển,... </b>
	</p>
	<h5>Công suất - Kích thước vùng nấu</h5>
	<p>
	- Hoạt động mạnh mẽ với 1800W (2000W khi gia nhiệt nhanh).
	<br>
	- Kích thước vùng nấu Ø20 cm.
	</p>
	<h5>Thiết kế - Chất liệu</h5>
	<p>
	- Bếp từ Crystal LY-T39 thiết kế sang trọng, có 1 vùng nấu, đặt gọn trên bàn ăn, kệ bếp.
	<br>
	- Mặt kính làm bằng kính Ceramic - Kanger (Trung Quốc) bóng sáng, chịu nhiệt tốt, tiện lau chùi.
	</p>
	<h5>Tiện ích</h5>
	<p>
	- Chế độ hẹn giờ tối đa 3 tiếng, kiểm soát thời gian nấu dễ dàng, hạn chế cháy khét.
	<br>
	- Tính năng giữ ấm đến 60°C, đảm bảo gia đình luôn được thưởng thức món ăn nóng ấm mọi lúc mình muốn.
	<br>
	- Điều khiển cảm ứng hiện đại với các ký hiệu minh họa rõ ràng, dễ hiểu, dễ thao tác.
	<br>
	- Cài đặt 10 mức điều chỉnh công suất và nhiệt độ linh hoạt lựa chọn thích hợp cho từng món ăn khác nhau.
	<br>
	- Bếp từ còn tích hợp chức năng Booster giúp nấu thức ăn nhanh chóng, tiết kiệm điện. 
	<h5>Tính năng an toàn</h5>
	<p>
	- Đảm bảo an toàn trong quá trình sử dụng với tính năng bảo vệ an toàn khi quá nhiệt.
	<br>
	- Khóa bảng điều khiển giúp tránh trường hợp trẻ em nghịch ngấm bấm lung tung làm thay đổi chương trình nấu gây nguy hiểm.
	</p>
	<h5>Chỉ sử dụng nồi, chảo có đáy nhiễm từ như gang, inox 430</h5>
	<p>
	<b>Lưu ý khi sử dụng:</b>
	- Không kéo nồi trên mặt bếp để tránh gây trầy xước mặt kính.
	<br>
	- Đặt bếp vững vàng, thăng bằng trên mặt bàn, kệ rồi mới khởi động.
	<br>
	- Nên dùng với nguồn điện ổn định, điện áp không quá cao hoặc quá thấp.
	<br><br>
	Bếp từ Crystal S15 có thiết kế nhỏ gọn, hẹn giờ tới 3 tiếng, mặt bếp kính Ceramic - Kanger ( Trung Quốc ) sáng bóng, sử dụng tiện lợi, an toàn, đáp ứng nhu cầu nấu ăn cơ bản,... sẽ là một lựa chọn hoàn toàn thích hợp cho các gia đình ít thành viên hoặc người sống một mình.
	</p>
' where id = 15
go

update products set [description] =N'
	<h5>Bếp từ Kangaroo màu đen sang trọng, hoa văn vàng đồng nổi bật, bắt mắt, thiết kế mỏng gọn đẹp mắt trong không gian sử dụng</h5>
	<p>
	Bếp từ công suất 2100W nấu ăn nhanh chín, tiết kiệm thời gian hiệu quả.
	</p>
	<h5>Mặt bếp bằng kính cường lực dày bền, chịu lực tốt, chịu nhiệt, chống trầy, sáng bóng dễ lau chùi</h5>
	<h5>Bảng điều khiển cảm ứng nhạy bén, 8 chế độ nấu tự động, có hẹn giờ tiện dụng</h5>
	<p>
	Nấu nước, hấp, nấu sữa, cháo, tiết kiệm điện để nấu các món hầm ninh, xào, nấu lẩu, hầm phục vụ cho gia đình bạn những bữa ăn ngon nhanh gọn. Thêm chức năng nấu tiết kiệm điện thuận tiện cho việc hâm nóng, ninh nhừ thực phẩm, ...
	</p>
	<h5>Hệ thống quạt và khe tản nhiệt hoạt động hiệu quả, giữ cho bếp luôn ổn định nhiệt, tránh hư hại</h5>
	<h5>Bếp từ kén nồi, cần chọn nồi nấu chuyên dụng để nấu ăn hiệu quả nhất</h5>
	<p>
	Bếp từ Kangaroo S16 đẹp mắt, dễ dùng, tiện lợi cao, giá bình dân, dễ tiêu dùng cho mọi nhà.
	</p>
' where id = 16
go

update products set [description] =N'
	<h5>Bếp từ đơn công suất 2000W giúp nấu ăn nhanh chóng, mức nhiệt tối đa lên đến 270°C</h5>
	<p>
	8 mức công suất: 100 - 500 - 800 - 1000 - 1300 - 1600 - 1800 - 2000W.
	</p>
	<h5>Bếp từ Sunhouse an toàn với trẻ nhỏ khi có chức năng khóa bảng điều khiển giúp vô hiệu hóa mọi hoạt động</h5>
	<h5>Tích hợp chức năng hẹn giờ trong khoảng 0 phút - 3 giờ giúp bạn lựa chọn thời gian nấu nướng phù hợp với từng món ăn</h5>
	<p>
	Đồng thời có thêm thời gian để chuẩn bị món ăn khác hoặc nội trợ, dọn dẹp nhà cửa. Mỗi lần nhấn "+" hoặc "-", thời gian sẽ tăng hoặc giảm 10 phút.
	</p>
	<h5>Bảng điều khiển cảm ứng tiếng Việt dễ hiểu, dễ dàng điều chỉnh 8 chế độ nấu cài sẵn</h5>
	<p>
	Chức năng dừng bếp tạm thời giúp bạn giải quyết công việc dang dở và quay trở lại sử dụng bếp tiện lợi.
	</p>
	<h5>Mặt bếp phủ kính Ceramic cường lực, dễ dàng lau chùi, chống trầy xước, chịu lực và chịu được nhiệt đến 760°C (trong điều kiện phòng thí nghiệm)</h5>
	<h5>Bếp từ có kiểu dáng nhỏ gọn, màu đen sang trọng kèm hoa văn tinh tế</h5>
	<p>
	Chân bếp có bọc cao su chống trơn trượt giúp bếp đứng vững.
	<br>
	Tính năng tự ngắt khi quá tải. Khi nồi quá nóng, bếp sẽ tự động tắt, còi báo. Bạn chỉ cần chờ vài phút để bếp nguội sau đó bật bếp lên và sử dụng bình thường
	</p>
	<h5>Sử dụng với nồi, chảo có đáy nhiễm từ như thép hoặc gang, sắt tráng men, inox 430, chảo/nồi với đường kính đáy trong khoảng 12 – 26 cm</h5>
	<p>
	Bếp tặng kèm nồi lẩu giúp bạn thuận tiện hơn khi sử dụng.
	<br>
	<br>
	Bếp từ Sunhouse S17 công suất 2000W, gia nhiệt tối đa 270°C, trang bị 8 chương trình cài đặt sẵn, chức năng khóa bảng điều khiển và hẹn giờ tối đa 3 tiếng, là sản phẩm gia dụng đáp ứng tốt nhu cầu sử dụng của 1 - 2 người, không gian bếp nhỏ.
	</p>
' where id = 17
go

update products set [description] =N'
	<h5>Bếp điện từ Kangaroo S18 công suất nấu 1800W, nấu ăn nhanh tiết kiệm thời gian, hiệu quả với gia đình bận rộn yêu thích nấu nướng</h5>
	<p>
	Thiết kế bếp với chân đế cao giúp thoát nhiệt tốt, chống ẩm hiệu quả, bảo vệ tốt hơn cho bếp từ.
	</p>
	<h5>Mặt bếp bằng Crystallite (tinh thể pha lê) cao cấp, sáng bóng, bền tốt, dễ vệ sinh</h5>
	<p>
	Crystallite là chất liệu có cấu trúc khá giống với ceramic nhưng có khả năng chịu nhiệt và độ sáng bóng cao hơn, giữ bếp sáng sạch hơn, mới lâu.
	</p>
	<h5>Bảng điều khiển nút nhấn điện tử đơn giản, dễ sử dụng, tiện lợi với các chế độ nấu cài đặt sẵn</h5>
	<p>
	Bao gồm: Đun nước, hầm, chiên xào, lẩu phục vụ tốt cho bữa ăn thường nhật tại gia đình.
	</p>
	<h5>Hẹn giờ nấu tiện dụng, hỗ trợ người nội trợ rảnh tay cho những công việc khác trong khi chờ thức ăn chín</h5>
	<h5>Tích hợp các tính năng bảo vệ an toàn</h5>
	<p>
	Bếp tự ngắt khi bếp quá nhiệt, thêm chức năng chống đun khô tự động ngắt bếp khi nấu nồi không có thức ăn hay khi cạn nước. Người dùng yên tâm hơn khi sử dụng bếp, không lo chạm cháy khi trong quá trình đun nấu.
	</p>
	<h5>Bếp từ kén nồi chỉ sử dụng được với nồi chảo có đáy nhiễm từ, đường kính đáy nồi giới hạn khoảng 12 - 20 cm</h5>
	<p>
	Chọn đúng nồi dùng với bếp từ sẽ giúp gia nhiệt nhanh hơn, đun nấu hiệu quả hơn, tiết kiệm điện năng tốt hơn.
	<br>
	<br>
	Ra mắt năm 2019 thương hiệu Việt Nam - sản xuất tại Trung Quốc. Bếp từ Kangaroo thiết kế bếp đơn gọn gàng, mang lại nhiều tiện ích, phù hợp với gia đình Việt.
	</p>
' where id = 18
go

update products set [description] =N'
	<h5>Bếp từ hồng ngoại Kangaroo S19 kiểu dáng hiện đại, đơn giản, thiết kế có thể lắp đặt âm sang trọng, tăng tính thẩm mỹ cho mọi gian bếp</h5>
	<p>
	Có 2 vùng nấu, trong đó 1 vùng nấu là bếp từ, 1 vùng nấu là bếp hồng ngoại, cho người dùng lựa chọn linh hoạt, nấu ăn tiện lợi. Bếp dùng tốt cho hộ gia đình hoặc kinh doanh ăn uống ...
	<br>
	Bếp từ có tổng công suất 3100W, sử dụng phích cắm.
	</p>
	<h5>Bảng điều khiển cảm ứng hiện đại, nhạy bén, dễ thao tác</h5>
	<p>
	Bếp từ Kangaroo có chế độ hẹn giờ nấu tiện dụng cho người nội trợ tùy chọn linh hoạt tùy theo công thức nấu.
	</p>
	<h5>Mặt bếp bằng kính chịu lực, chịu nhiệt, chống trầy xước tốt, độ bền cao, lau chùi đơn giản</h5>
	<h5>Vùng nấu từ kích thước 19 cm, công suất 1300W, vùng nấu hồng ngoại kích thước 20 cm, công suất 1800W, nấu ăn nhanh, tiết kiệm điện</h5>
	<p>
	Vùng nấu từ sử dụng được với nồi chảo có đáy nhiễm từ; có cảnh báo “E0” – bếp không hoạt động khi không đặt nồi hoặc nồi nấu không phù hợp.
	</p>
	<h5>Vùng nấu hồng ngoại sử dụng được với mọi loại nồi chảo, có thể nướng trên mặt bếp tiện lợi</h5>
	<h5>Bếp có khóa bảng điều khiển, tính năng tự ngắt điện khi bếp hoạt động quá tải</h5>
	<p>
	Khi chọn tính năng khóa bảng điều khiển, bảng điều khiển sẽ bị vô hiệu hóa khi bếp đang hoạt động, an toàn hơn đặc biệt cho gia đình có trẻ nhỏ.
	<br>
	Bếp tự động ngắt sau 120 phút quên không tắt bếp, phòng tránh nguy cơ cháy nổ, hỏa hoạn.
	<br>
	<br>
	Sản phẩm đẹp, tiện ích, dùng an toàn, giá tốt, thương hiệu thân thuộc, bếp từ hồng ngoại Kangaroo xứng đáng là bạn đồng hành của chị em nội trợ.
	</p>
' where id = 19
go

update products set [description] =N'
	<h5>Bếp từ Toshiba thiết kế hiện đại, màu đen lịch lãm, 4 góc bo cong mềm mại, tạo điểm nhấn cho không gian sử dụng thêm sang trọng</h5>
	<p>
	Kiểu dáng bếp từ đơn trang bị 1 vùng nấu nhỏ gọn cho bạn tiện đặt trong căn bếp hẹp hoặc trên bàn ăn để làm các món nóng dễ dàng hơn.
	</p>
	<h5>Mặt bếp bằng kính Ceramic HEGON cao cấp (Đức) bóng sáng, hạn chế trầy xước, chịu lực 150 kg và chịu nhiệt cao đến 600°C, dễ làm sạch</h5>
	<h5>Công suất mạnh mẽ 2000W, gia nhiệt nhanh nhờ mâm nhiệt kép giúp thức ăn chín mau, tiết kiệm điện năng hiệu quả</h5>
	<h5>Tùy chỉnh 4 chế độ cài đặt sẵn, hẹn giờ, công suất nấu tiện lợi với bảng điều khiển cảm ứng hiện đại</h5>
	<p>
	Các chế độ cài đặt sẵn gồm nấu nước, giữ ấm, chiên và công suất tối đa. Đặc biệt, chế độ công suất tối đa chỉ có trên bếp từ đôi giúp tăng tốc độ nấu, cho món ăn được nấu nhanh hơn.
	</p>
	<h5>Công nghệ chống thấm, ngăn chất lỏng chảy tràn vào linh kiện bên trong bếp và gây hỏng hóc</h5>
	<h5>Bếp từ sử dụng các nồi, chảo có đáy từ</h5>
	<p>
	Cực tiết kiệm chi phí khi chọn mua sản phẩm này, bởi bạn sẽ được tặng kèm 1 nồi inox đáy từ phù hợp, sẵn sàng dùng ngay khi mang về nhà.
	</p>
	<p>
	Bếp từ Kangaroo có chế độ hẹn giờ nấu tiện dụng cho người nội trợ tùy chọn linh hoạt tùy theo công thức nấu.
	</p>
	<h5>Các tính năng an toàn đa dạng</h5>
	<p>
	Gồm khóa bàn phím, cảnh báo mặt bếp nóng, tự ngắt khi không có nồi, có âm báo khi nồi chảo không phù hợp giúp kéo dài tuổi thọ cho bếp và bảo vệ người dùng tối đa trong quá trình sử dụng.
	</p>
	<p>
	<b>Lưu ý:</b>
	<br>
	- Đặt bếp ngay ngắn trên kệ, bàn rồi mới bật bếp để tránh sản phẩm nghiêng, rơi.
	<br>
	- Khi nấu ăn xong nên đợi quạt tản nhiệt ngừng quay hoàn toàn rồi mới rút phích cắm điện ra. 
	<br>
	- Làm sạch mặt bếp với khăn vải mềm, không dùng búi sắt để hạn chế làm trầy xước mặt bếp.
	<br>
	<br>
	Bếp từ Toshiba S20 với thiết kế nhỏ gọn, hiện đại, đa chức năng, giá tốt, sản phẩm của thương hiệu Nhật Bản - Toshiba nổi tiếng, tin tưởng sẽ là trợ thủ tuyệt vời cho bạn làm bếp dễ dàng hơn.
	</p>
' where id = 20
go

update products set [description] =N'
	<h5>Bếp từ hồng ngoại Sunhouse được thiết kế theo phong cách Tây Ban Nha, sang trọng, thời thượng, kết hợp bếp từ và bếp hồng ngoại, nấu ăn cực tiện dụng</h5>
	<p>
	Công suất tổng lớn tới 3600 W ( bếp từ 1800W - bếp hồng ngoại 1800W ) cho khả năng làm nóng nhanh gấp 2 lần các bếp điện thông thường, nấu ăn nhanh chóng.
	<br>
	Với tổng công suất này, bếp sử dụng điện nối qua aptomat ( CB ).
	</p>
	<h5>Mặt bếp từ Sunhouse cực mỏng chỉ 0.4 cm, lắp đặt âm bếp dễ dàng cho không gian nấu ăn rộng rãi, thông thoáng hơn</h5>
	<h5>Mặt bếp bằng chất liệu kính cường lực cao cấp chịu nhiệt chịu lực tốt, chống trầy xước, bóng loáng cho độ mới lâu</h5>
	<h5>Bảng điều khiển cảm ứng, màn hình hiển thị rõ nét cho người dùng điều chỉnh các chế độ nấu, hẹn giờ, mức công suất linh hoạt, chính xác</h5>
	<h5>Sử dụng được mọi loại nồi với mặt bếp hồng ngoại, chỉ sử dụng được nồi có đế nhiễm từ với mặt bếp từ</h5>
	<h5>An toàn khi sử dụng với chức năng khóa bảng điều khiển, tự động ngắt khi quá nhiệt</h5>
	<p>
	Chức năng khóa bảng điều khiển khi sử dụng sẽ vô hiệu hóa toàn bộ bàn phím chức năng ngăn người dùng thay đổi các cài đặt trước đó và giúp bảo vệ người dùng, nhất là trong gia đình có trẻ nhỏ tinh nghịch, táy máy.
	<br>
	Chức năng tự ngắt khi quá tải vận hành khi bếp hoạt động quá tải, bị quá nhiệt giúp kéo dài tuổi thọ cho thiết bị tối đa.
	<br><br>
	Bếp từ hồng ngoại Sunhouse S21 mẫu mã hiện đại, nấu ăn đa dạng, tiện lợi, dùng bền lâu, thích hợp cho mọi căn bếp gia đình.
	</p>
' where id = 21
go

update products set [description] =N'
	<h5>Bếp từ đơn công suất 1800W gia nhiệt nhanh, nấu chín món ăn nhanh chóng, tiết kiệm thời gian</h5>
	<p>
	Công nghệ làm nóng bằng từ trường giúp truyền nhiệt nhanh lên nồi/chảo..
	</p>
	<h5>Trang bị 7 chế độ gồm: nấu lẩu, giữ ấm, súp, hầm, hấp, xào, chiên dễ dàng thực hiện các món ăn cơ bản</h5>
	<h5>Bảng điều khiển nút nhấn tiếng Việt dễ hiểu, dễ dàng sử dụng thao tác điều chỉnh như mong muốn</h5>
	<p>
	Chức năng kiểm tra điện năng tiêu thụ chỉ với 1 thao tác: nhấn nút “Điện năng”, mức tiêu hao năng lượng hiện trên màn hình LED. Sau 5 giây, màn hình trở lại ban đầu.
	<br>
	Bếp từ có chức năng hẹn giờ trong khoảng 0 phút - 3 giờ giúp bạn lựa chọn thời gian nấu nướng phù hợp với từng món ăn, đồng thời có thêm thời gian để chuẩn bị món ăn khác hoặc nội trợ, dọn dẹp nhà cửa.
	</p>
	<h5>Mặt bếp phủ kính Ceramic cường lực, dễ làm sạch, chống trầy xước, chịu lực và chịu được nhiệt đến 760°C ( trong điều kiện phòng thí nghiệm )</h5>
	<h5>Bếp từ Sunhouse có kiểu dáng nhỏ gọn, màu đen sang trọng kèm hoa văn tinh tế</h5>
	<p>
	Chân bếp có bọc cao su chống trơn trượt giúp bếp đứng vững.
	</p>
	<h5>Sử dụng an toàn với tính năng tự ngắt khi quá tải</h5>
	<p>
	Khi nồi quá nóng, bếp sẽ tự động tắt, còi báo. Bạn chỉ cần chờ vài phút để bếp nguội sau đó bật bếp lên và sử dụng bình thường.
	<br>
	Bếp từ tặng kèm nồi lẩu giúp nấu lẩu, nấu canh tiện lợi hơn.
	</p>
	<h5>Sử dụng với nồi, chảo có đáy nhiễm từ (inox 430, gang) đường kính đáy trong khoảng 14 - 26 cm</h5>
	<p>
	<b>Lưu ý để sử dụng bếp bền tốt:</b>
	<br>
	- Tham khảo kỹ hướng dẫn của nhà sản xuất trước khi vận hành bếp.
	<br>
	- Sử dụng khi nguồn điện áp ổn định để kéo dài tuổi thọ sản phẩm tối đa.
	<br>
	- Không đặt bếp gần nguồn nhiệt cao, vật dễ cháy nổ.
	<br>
	- Làm sạch bề mặt bếp với khăn vải mềm và miếng bọt biển để tránh gây trầy xước mặt bếp.
	<br>
	<br>
	Bếp từ Sunhouse S22 với kiểu dáng gọn đẹp, trang bị 7 chế độ nấu tiện lợi, chức năng hẹn giờ tối đa 3 tiếng, kiểm tra lượng điện năng tiêu thụ cùng tính năng tự ngắt khi quá nhiệt sẽ là sự lựa chọn hoàn hảo cho căn bếp nhỏ.
	</p>
' where id = 22
go

update products set [description] =N'
	<h5>Mặt bếp hồng ngoại bằng kính chịu nhiệt sáng bóng, nhẵn mịn, tiện vệ sinh</h5>
	<h5>Bếp dùng được mọi loại nồi</h5>
	<h5>Bếp hồng ngoại đơn với công suất 2000W, nấu ăn nhanh chóng, tiết kiệm điện năng</h5>
	<h5>Bảng điều khiển cảm ứng hiện đại, màn hình hiển thị dễ theo dõi, dễ thao tác</h5>
	<h5>Nấu ăn dễ dàng với 5 chế độ nấu được cài đặt sẵn</h5>
	<p>
	Bếp hồng ngoại Sunhouse SHD 6005 có các chế độ nấu là nấu lẩu, nấu súp, nướng, chiên/xào, hầm, bạn có thể thỏa thích chế biến nhiều món ăn ngon mà không cần có kinh nghiệm nấu ăn phong phú.
	</p>
	<h5>Quạt tản nhiệt làm mát bếp nhanh, kéo dài tuổi thọ của sản phẩm</h5>
	<h5>Chế độ hẹn giờ nấu linh hoạt</h5>
	<p>
	Cho phép bạn lên kế hoạch nấu nướng và làm việc nhà cùng lúc, giúp tiết kiệm thời gian tối đa.
	</p>
	<h5>Chức năng khóa bảng điều khiển, đèn báo mặt bếp còn nóng tiện dụng</h5>
	<p>
	Trong khi nấu nướng, bạn có thể sử dụng chức năng này để vô hiệu hóa toàn bộ bảng điều khiển nếu cần ra ngoài, không thể trông chừng bếp nhưng sợ trẻ nhỏ táy máy bấm vào các phím chức năng gây nguy hiểm cho trẻ và làm gián đoạn quá trình nấu.
	<br>
	Đèn báo mặt bếp còn nóng tránh cho người dùng các nguy cơ bỏng do tiếp xúc với bề mặt bếp ngay sau khi nấu.
	</p>
	<h5>Đi kèm bếp có vỉ nướng giúp làm món nướng trực tiếp trên bếp dễ dàng</h5>
	<p>
	Bếp hồng ngoại Sunhouse S23 là công cụ nấu nướng đắc lực cho những ai bận rộn, có sở thích nấu nướng.
	</p>
' where id = 23
go

update products set [description] =N'
	<p>
	<b>Sản phẩm bếp hồng ngoại 3 vùng nấu lắp âm Smeg S24 chất lượng cao thương hiệu Smeg của Ý, sản xuất tại Ý với thiết kế lắp âm sang trọng, cao cấp chuẩn Châu Âu, mang đến nét đẹp cho không gian bếp hiện đại..</b>
	</p>
	<h5>Công suất - Kích thước vùng nấu</h5>
	<p>
	- Tổng công suất đạt 5700W, nấu ăn nhanh, tiết kiệm thời gian cho việc bếp núc.
	<br>
	- Vùng nấu trái phía trên công suất 1200W, vùng nấu trái dưới 1800W, vùng nấu phải với 3 có 3 công suất 1050/1950/2700W hoạt động mạnh mẽ.
	<br>
	- Vùng nấu trái trên đường kính Ø14.8 cm, vùng nấu trái dưới Ø18.4 cm, vùng nấu phải có 3 vòng nhiệt đường kính lần lượt Ø15.0 - Ø21.6 - Ø28.8 cm cho phép sử dụng linh hoạt với nhiều cỡ nồi chảo vô cùng tiện tiện lợi.
	</p>
	<h5>Thiết kế</h5>
	<p>
	- Bếp hồng ngoại Smeg S24 thiết kế hiện đại, sang đẹp với 3 vùng đa kích thước rộng rãi.
	<br>
	- Bếp hồng ngoại có mặt kính Ceramic - Smeg cao cấp của Ý, khả năng chịu lực và chịu nhiệt tốt, ít bị trầy xước, giữ bếp gia nhiệt hiệu quả, luôn sáng đẹp như mới.
	</p>
	<h5>Tiện ích</h5>
	<p>
	- 9 mức công suất và nhiệt độ, linh hoạt tùy chỉnh cho phù hợp với từng món ăn khác nhau.
	<br>
	- Bảng điều khiển cảm ứng nhạy, điều chỉnh độc lập 3 vùng nấu.
	<br>
	- Trang bị chức năng hẹn giờ thông minh hỗ trợ người nội trợ kiểm soát tốt thời gian sử dụng bếp, rảnh tay cho những công việc khác mà không lo món nấu quá nhiệt.
	<br>
	- Bếp không kén nồi, dùng được với mọi loại nồi, chảo, tiết kiệm đáng kể chi phí đầu tư mua dụng cụ nấu, có thể tận dụng các nồi chảo có sẵn.
	</p>
	<h5>Tính năng an toàn</h5>
	<p>
	- Khóa bảng điều khiển, đảm bảo an toàn cho gia đình, đặc biệt gia đình có con nhỏ.
	<br>
	- Tính năng tự ngắt khi quá nhiệt giúp tránh cháy nổ.
	<br>
	- Tự ngắt khi tràn nước.
	<br>
	- Cảnh báo mặt bếp còn nóng, tránh bị bỏng.
	</p>
	<p>
	<b>Sử dụng bếp hồng ngoại an toàn</b>
	<br>
	- Lắp đặt bếp âm theo đúng hướng dẫn của nhà sản xuất, đảm bảo khu vực đun nấu thông thoáng.
	<br>
	- Tránh các tác động gây trầy xước mặt bếp sẽ ảnh hưởng đến hiệu quả gia nhiệt, mất thẩm mỹ.
	<br>
	- Bếp hồng ngoại có thể lưu nhiệt sau quá trình sử dụng, cẩn trọng để tránh bị phỏng.
	<br>
	<br>
	Bếp hồng ngoại Smeg S24 là thương hiệu Ý, sản xuất tại Ý chất lượng cao, thiết kế 3 vùng nấu rộng rãi, công suất lớn 5700W, 9 mức nhiệt điều khiển cảm ứng chọn cùng nhiều tính năng hẹn giờ, khóa điều khiển, cảnh báo bếp nóng là một lựa chọn hoàn hảo cho gia đình bạn.
	</p>
' where id = 24
go

update products set [description] =N'
	<p>
	<b>Bếp hồng ngoại đôi lắp âm Smeg S25 với nhiều tính năng an toàn đảm bảo cho người dùng, có xuất xứ từ Ý đạt tiêu chuẩn Châu Âu về chất lượng, dễ dàng tuỳ chỉnh công sức với bảng điều khiển cảm ứng,... đây chắc chắn là một trợ thủ đắc lực cho các gia đình trong việc chế biến món ăn.</b>
	</p>
	<h5>Tổng công suất - Công suất từng vùng - Kích thước vùng nấu</h5>
	<p>
	- Tổng công suất 2900W, chế biến thức ăn nhanh chóng.
	<br>
	- Công suất từng vùng: bếp trên 700/1700W - bếp dưới 1200W.
	<br>
	- Kích thước vùng nấu: bếp trên: Ø 12.4 - 18.4 cm - bếp dưới: Ø14.8 cm.
	</p>
	<h5>Xuất xứ - Thiết kế - Chất liệu</h5>
	<p>
	- Bếp hồng ngoại Smeg của thương hiệu Smeg - Ý, sản xuất tại Ý đạt chất lượng cao cấp chuẩn Châu Âu.
	<br>
	- Bếp có thiết kế lắp âm 2 vùng nấu, kiểu dáng dọc, phù hợp cho không gian bếp hẹp mà vẫn tạo được cảm giác sang trọng cho nhà bếp.
	<br>
	- Mặt bếp làm bằng kính Ceramic - Schott Ceran (Đức) bóng loáng, chịu lực, chịu nhiệt tốt.
	</p>
	<h5>Tiện ích</h5>
	<p>
	- Có 9 mức gia nhiệt dễ dàng tùy chọn qua bảng điều khiển bằng cảm ứng.
	<br>
	- Bếp hồng ngoại sử dụng đa dạng loại nồi nấu, tận dụng được nồi, chảo sẵn có trong nhà, tiết kiệm chi phí.
	<br>
	- Thiết lập thời gian nấu phù hợp với từng món ăn để có hương vị thơm ngon, giàu dưỡng chất với tính năng hẹn giờ từ 1 - 99 phút.
	</p>
	<h5>Tính năng an toàn</h5>
	<p>
	- Khóa bảng điều khiển: kích hoạt sẽ vô hiệu toàn bộ bàn phím, bảo vệ và ngăn người dùng thay đổi cài đặt đã được thiết lập trước đó.
	<br>
	- Tự ngắt khi bếp nóng quá tải: nếu nhiệt độ bếp tăng quá cao so với nhiệt độ mà hãng quy định thì bếp sẽ tự động ngắt điện.
	<br>
	- Cảnh báo mặt bếp nóng: khi bề mặt bếp nóng quá mức quy định, thiết bị phát ra cảnh báo để tránh cho bạn chạm tay vào mặt bếp, bị nóng, bỏng.
	<br>
	- Tự tắt bếp khi nước tràn: sản phẩm tự động tắt khi có chất lỏng từ dụng cụ nấu chảy tràn xuống mặt bếp.
	</p>
	<h5>Lưu ý:</h5>
	<p>
	- Xem kỹ càng những chỉ dẫn của nhà sản xuất cung cấp trong sách hướng dẫn sử dụng để dùng hiệu quả, an toàn.
	<br>
	- Khi xảy ra sự cố mà bạn không biết chỉnh sửa, nên liên hệ trung tâm bảo hành để được hỗ trợ đúng cách.
	<br>
	- Không trượt nồi, chảo trên bề mặt bếp vì dễ gây trầy xước.
	<br>
	<br>
	Bếp hồng ngoại Smeg S25 là thiết bị nấu ăn hiện đại, chất lượng tốt, nấu ăn nhanh với tổng công suất 2900W, mặt kính Ceramic - Schott Ceran (Đức) sang trọng, hẹn giờ tối đa 99 phút, hỗ trợ đa dạng chức năng tiện ích, an toàn,.. chắc chắn sẽ là một thiết bị gia dụng không thể thiếu trong mỗi gia đình.
	</p>
' where id = 25
go

update products set [description] =N'
	<h5>Bếp hồng ngoại Torino thiết kế hiện đại, tinh tế, màu đen thanh lịch</h5>
	<p>
	Được làm theo kiểu hình chữ nhật ngang với 2 bếp nằm song song, phù hợp để đặt trên kệ bếp có sẵn hoặc lắp đặt âm. Bếp hồng ngoại đôi có 2 vùng nấu, người nội trợ nấu được 2 món ăn đồng thời, chuẩn bị bữa cơm gia đình tốc hành, không tốn nhiều thời gian.
	</p>
	<h5>Hoạt động với tổng công suất 3000W, bếp trái 1800W, bếp phải 1200W, nấu ăn nhanh chóng</h5>
	<p>
	Bếp có mâm nhiệt E.G.O của châu Âu, độ bền cao, dùng tiết kiệm điện hơn.
	<br>
	Với tổng công suất 3000W, bếp sử dụng điện nối qua aptomat (CB).
	<h5>Mặt kính Schott Ceran của Đức cao cấp siêu bền, bóng sáng, chịu được trọng lượng lớn, nhiệt độ cao, dễ lau chùi</h5>
	<h5>Trang bị điều khiển cảm ứng nhạy bén cho từng bếp, tùy chỉnh 9 mức công suất, hẹn giờ chính xác, dễ dàng</h5>
	<p>
	Chế độ hẹn giờ cho phép bạn chọn thời gian nấu tùy thích, khi hết thời gian hẹn, bếp sẽ tự động ngắt, đảm bảo món ăn không bị cháy khét, chín quá.
	</p>
	<h5>Bếp hồng ngoại dùng được mọi loại nồi từ nồi nhôm, inox đến thủy tinh, đất, có thể nướng ngay trên mặt bếp</h5>
	<p>
	Dùng linh hoạt, không cần mất thêm chi phí mua nồi mới.
	</p>
	<h5>Sử dụng an toàn với tính năng cảnh báo bếp nóng, tự ngắt khi bếp nóng quá tải, khoá an toàn</h5>
	<p>
	Với cảnh báo bếp nóng người dùng tránh chạm tay vào mặt bếp, không bị bỏng, nóng khi nấu nướng. Khi bếp nóng quá tải để bảo vệ mạch và người dùng, bếp sẽ tự động ngắt.
	<br>
	Trường hợp sử dụng khóa an toàn, bảng điều khiển sẽ bị vô hiệu hóa, đảm bảo an toàn cho gia đình có trẻ nhỏ tối đa.
	<p>
	<p>
	<b>Lưu ý:</b>
	- Không đặt gần nguồn nhiệt cao, nguồn nước để tránh làm giảm tuổi thọ của bếp.
	<br>
	- Không tự ý sửa chữa bếp, nếu có lỗi, hãy liên hệ trung tâm bảo hành hoặc thợ sửa chuyên nghiệp.
	<br>
	- Không đổ nước trực tiếp lên mặt bếp để vệ sinh, nên dùng khăn vải ẩm chà lau sẽ giúp loại bỏ vết bẩn dễ dàng.
	<br>
	<br>
	Bếp hồng ngoại đôi Torino S26 đến từ thương hiệu Italia - Torino nổi tiếng, sản xuất tại Trung Quốc, chất lượng tốt, mẫu đẹp, hỗ trợ bạn chuẩn bị bữa cơm gia đình tiện lợi mỗi ngày.
	</p>
' where id = 26
go

update products set [description] =N'
	<h5>Lò nướng Sharp thiết kế hiện đại, vỏ và khoang lò bằng chất liệu thép không gỉ sáng bóng, dễ lau chùi, bền bỉ</h5>
	<h5>Dung tích 38 lít, kiểu lò nướng thùng có khả năng nướng gà nguyên con khoảng 2 kg trở xuống dễ dàng</h5>
	<h5>Công nghệ làm nóng bằng điện trở, công suất 1800W giúp làm nóng lò nhanh, nướng chín thực phẩm nhanh</h5>
	<h5>Lò nướng gia đình có điều khiển núm vặn đơn giản, dễ hiểu, dễ thao tác đối với mọi người dùng</h5>
	<h5>Đèn chiếu sáng bên trong khoang lò giúp bạn quan sát quá trình nướng dễ dàng, không cần mở cửa lò ra</h5>
	<h5>Có quạt đối lưu tạo luồng gió luân chuyển nhiệt lượng đều trong khoang lò, nướng thực phẩm chín đều hơn</h5>
	<h5>Chức năng nướng xiên quay giúp bạn nướng thực phẩm kích cỡ lớn, nguyên con tiện lợi, chín ngon</h5>
	<h5>Lò nướng có bộ que xiên cho phép bạn nướng thịt, rau củ xiên que dễ dàng</h5>
	<h5>Tặng kèm lò có khay nướng, khay Pizza, khay hứng, vỉ nướng, xiên quay, tay cầm xiên quay, tay cầm khay nướng</h5>
	<p>
	Người nội trợ chuẩn bị món ăn nào sử dụng khay, vỉ, tay cầm phù hợp để nấu ăn đơn giản, nhanh gọn hơn.
	<br>
	Lò nướng Sharp S27 38 lít của thương hiệu nổi tiếng Nhật Bản, chất lượng tốt, dùng bền, nướng thịt ngon, nên chọn mua lò nướng này cho gia đình đông người.
	</p>
	<p>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp để đựng thức ăn cho vào lò nướng.
	<br>
	- Sử dụng hộp thủy tinh chuyên dụng để đựng thức ăn vào lò nướng.
	<br>
	- Không để lò nướng gần bếp ga hoặc các vật dễ bắt lửa như rèm cửa, giấy, ...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Nên sử dụng khăn ướt để lau khoang lò.
	</p>
' where id = 27
go

update products set [description] =N'
	<h5>Lò nướng Kangaroo dung tích 40 lít, lựa chọn phù hợp cho gia đình 4 – 6 thành viên</h5>
	<p>
	Thiết kế sang trọng với vỏ ngoài bằng thép sơn tĩnh tiện sáng bóng, màu sắc hiện đại, bắt mắt, làm đẹp không gian bếp sử dụng. 
	</p>
	<h5>Khoang lò thép không gỉ bền bỉ, nướng an toàn, dễ dàng vệ sinh sau mỗi lần sử dụng</h5>
	<h5>Lò nướng với công suất 1600 W, thêm quạt đối lưu luân chuyển khí nóng giúp nướng thức ăn chín thật nhanh, chín đều và thơm ngon</h5>
	<h5>Trang bị thanh đốt điện trở kép gia nhiệt hiệu quả, nướng nhanh và đều cả 2 mặt</h5>
	<p>
	Cho món nướng giòn đều ngoài mặt, thơm mềm bên trong, giữ nguyên hương vị và dưỡng chất.
	</p>
	<h5>Sử dụng lò nướng thật đơn giản với bảng điều khiến núm xoay, các nút chức năng riêng biệt, rõ ràng, dễ dùng</h5>
	<p>
	Tùy chỉnh nhiệt độ nướng từ 100 – 250 độ C phù hợp với từng loại thực phẩm.
	<br>
	Tùy chọn nướng thanh nhiệt trên, thanh nhiệt dưới hoặc cả 2 thanh nhiệt để có món nướng chín ngon như ý.
	<br>
	Chức năng hẹn giờ lên đến 60 phút hỗ trợ người dùng rảnh tay chế biến đồng thời các món ăn khác cho bữa ăn gia đình.
	</p>
	<h5>Lò nướng hỗ trợ thêm nướng xiên quay</h5>
	<p>
	Nướng gà, vịt nguyên con, nướng thịt tảng lớn dễ dàng, thơm ngon, thêm lựa chọn hấp dẫn cho những bữa tiệc thân mật của gia đình.
	<br>
	Phụ kiện đi kèm khi mua sản phẩm: Khay nướng, vỉ nướng inox, xiên quay, bộ tay cầm tiện dụng.
	</p>
	<p>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp để đựng thức ăn cho vào lò nướng.
	<br>
	- Sử dụng hộp thủy tinh chuyên dụng để đựng thức ăn vào lò nướng.
	<br>
	- Không để lò nướng gần bếp gas hoặc các vật dễ bắt lửa như rèm cửa, giấy, ...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Nên sử dụng khăn ướt để lau khoang lò.
	<br>
	<br>
	Lò nướng Kangaroo S28 40 lít lựa chọn tiện ích, giá rẻ, gia tăng lựa chọn cho bữa ăn gia đình với những món nướng thơm ngon, hấp dẫn nhất.
	</p>
' where id = 28
go

update products set [description] =N'
	<h5>Lò nướng thùng Sanaky dung tích 50 lít với thiết kế hình chữ nhật màu đen sang trọng, hài hòa với mọi không gian căn bếp</h5>
	<p>
	Dung tích lớn phù hợp cho gia đình đông thành viên hoặc cửa hàng bánh nhỏ.
	</p>
	<h5>Công suất lên tới 2000W nướng chín thức ăn nhanh, tiết kiệm thời gian</h5>
	<h5>Lò nướng có chức năng cài đặt thời gian hẹn giờ nướng tối đa 60 phút, giúp người dùng kiểm soát được rủi ro cháy khét thức ăn, tận dụng thời gian để chế biến hoặc làm những công việc khác</h5>
	<h5>Khoang lò được sản xuất chuyên biệt bằng chất liệu thép không gỉ, dễ vệ sinh</h5>
	<h5>Bảng điều chỉnh nhiều chức năng nướng nhờ vào 3 núm điều chỉnh bằng cơ và xoay dễ dàng</h5>
	<p>
	Núm trên cùng điều chỉnh nhiệt độ từ 100°C đến tối đa 230°C giúp người dùng có thể tăng giảm nhiệt độ để thực phẩm chín nhanh chậm theo ý muốn.
	<br>
	Núm ở giữa điều chỉnh chế độ nướng như: Thanh nhiệt trên/dưới kết hợp quạt đối lưu, thanh nhiệt trên kết hợp quạt đối lưu, thanh nhiệt trên/ dưới, thanh nhiệt trên kết hợp xiên quay, thanh nhiệt trên/ dưới kết hợp xiên quay và quạt đối lưu, tắt.
	<br>
	Núm dưới cùng có chức năng hẹn giờ và ngắt điện có tiếng chuông báo nhắc người sử dụng.
	</p>
	<h5>Đèn trong khoang giúp dễ dàng quan sát tình trạng thức ăn mà không cần mở cửa lò nướng</h5>
	<h5>Quạt đối lưu làm cho thức ăn chín đều, giữ cho thức ăn không bị khô</h5>
	<h5>Kết hợp với xiên quay nướng vừa tỏa nhiệt vừa xoay đều thức ăn, giúp món ăn chín đều hấp dẫn</h5>
	<p>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp, nilon để đựng thức ăn.
	<br>
	- Nên sử dụng khay, khuôn nướng bằng kim loại như nhôm, gang, inox chịu nhiệt cao và các hộp bằng thủy tinh chuyên dụng.
	<br>
	- Không để lò nướng gần bếp gas hoặc các vật dễ bắt lửa như rèm cửa, giấy,...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Nên sử dụng khăn ướt để lau khoang lò.
	<br>
	<br>
	Lò nướng Sanaky S29 50 lít dung tích khủng, chế biến thức ăn nhanh chóng mà vẫn đảm bảo dinh dưỡng cho thực phẩm, phục vụ bữa ăn cho gia đình thân yêu.
	</p>
' where id = 29
go

update products set [description] =N'
	<h5>Lò nướng Sharp mang phong cách thiết kế truyền thống nhưng khá đẹp mắt, màu sắc sang trọng, kiểu dáng gọn gàng, làm đẹp không gian lắp đặt sử dụng</h5>
	<p>
	Dung tích lớn tới 46 lít, lò nướng bánh phục vụ nấu nướng chuyên nghiệp tốt từ gia đình đến nhà hàng, khu kinh doanh ăn uống ...
	</p>
	<h5>Khoang lò nướng đa năng bằng thép mạ kẽm sáng bóng, độ bền cao, nướng thực phẩm an toàn, dễ lau chùi sau mỗi lần dùng</h5>
	<p>
	Đèn chiếu sáng trong khoang lò tiện lợi khi cần quan sát món nướng trong suốt quá trình nấu ăn.
	</p>
	<h5>Đặc biệt, kèm thêm nướng xiên quay dùng nướng gà vịt nguyên con cỡ lớn dễ dàng, tiện dụng, thơm ngon</h5>
	<h5>Trục nướng xiên que nướng thịt, xúc xích, rau củ... xiên que cực ngon, chín đều, đẹp mắt, nhanh gọn</h5>
	<h5>Điều khiển bằng núm xoay, điều chỉnh nhiệt độ từ 90 – 250 độ C tùy chọn theo món nướng, nướng ngon từ các loại bánh đến thịt cá, rau củ, ...</h5>
	<p>
	5 mức công suất với công suất nướng tối đa tới 2000 W không chỉ nướng nhanh mà còn cho thực phẩm có độ giòn tuyệt hảo.
	<br>
	Chế độ hẹn giờ lên đến 120 phút cho người dùng chủ động thời gian nấu, linh hoạt hơn với các công việc bếp núc khác.
	</p>
	<h5>Khoang lò được sản xuất chuyên biệt bằng chất liệu thép không gỉ, dễ vệ sinh</h5>
	<h5>Bảng điều chỉnh nhiều chức năng nướng nhờ vào 3 núm điều chỉnh bằng cơ và xoay dễ dàng</h5>
	<p>
	<h5>Lò làm nóng bằng thanh nhiệt với quạt đối lưu đẩy khí nóng luân chuyển nhanh và đều khắp khoang lò, giúp món nướng chín đều, ngon, đẹp màu</h5>
	<h5>Lò nướng gia đình lấy thức ăn an toàn, nhanh chóng với phụ kiện tiện lợi</h5>
	<p>
	Lò nướng Sharp S30 46 lít, sản phẩm lò nướng tốt, dung tích lớn tiện lợi, thiết kế đẹp, nướng ngon, dễ dùng, chất lượng cao đáng chọn mua.
	<br>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp để đựng thức ăn cho vào lò nướng.
	<br>
	- Sử dụng hộp thủy tinh chuyên dụng để đựng thức ăn vào lò nướng.
	<br>
	- Không để lò nướng gần bếp gas hoặc các vật dễ bắt lửa như rèm cửa, giấy, ...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Nên sử dụng khăn ướt để lau khoang lò.
' where id = 30
go

update products set [description] =N'
	<h5>Lò nướng Bluestone thiết kế đẹp mắt, sang trọng với vỏ ngoài bằng thép sơn tĩnh điện màu đen tinh tế</h5>
	<p>
	Công suất 2000 W giúp nướng nhanh chóng, giòn đều.
	</p>
	<h5>Dung tích 38 lít đủ rộng để nướng gà nguyên con dưới 1.5 kg, 1 ổ bánh bông lan tầm 22 cm ...</h5>
	<h5>Lò nướng đa năng có bảng điều khiển nút vặn dễ sử dụng ngay cả với người lớn tuổi</h5>
	<h5>Bên trong lò còn có đèn giúp quan sát quá trình nướng đơn giản, dễ dàng</h5>
	<p>
	Lò nướng bánh gia đình còn có quạt đối lưu trong khoang lò giúp luân chuyển nhiệt độ đều hơn.
	</p>
	<h5>Lò nướng có xiên quay giúp nướng gà vịt nguyên con dễ dàng hơn</h5>
	<p>
	Lò nướng Bluestone S31 38 lít thương hiệu uy tín, lò nướng tốt, chất lượng, nướng thức ăn ngon được nhiều người tin dùng.
	</p>
	<p>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp để đựng thức ăn cho vào lò nướng.
	<br>
	- Sử dụng hộp thủy tinh chuyên dụng để đựng thức ăn vào lò nướng.
	<br>
	- Không để lò nướng gần bếp gas hoặc các vật dễ bắt lửa như rèm cửa, giấy, ...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Nên sử dụng khăn ướt để lau khoang lò.
	</p>
' where id = 31
go

update products set [description] =N'
	<p>
	<b>Lò nướng Sunhouse Mama 40 lít có thiết kế hiện đại, sang trọng, công nghệ làm nóng điện trở nhiệt cùng 5 chế độ nướng,... hứa hẹn mang lại trải nghiệm tích cực, đáp ứng tốt nhu cầu dùng các món nướng trong gia đình.</b>
	</p>
	<h5>Công suất - Dung tích - Công nghệ làm nóng</h5>
	<p>
	- Công suất nướng 1550W, nhiệt độ lò từ 100 - 240°C, hẹn giờ nấu lên đến 60 phút tiện dụng, giúp chủ động thời gian nấu nướng.
	<br>
	- Dung tích lò 40 lít, có thể nướng được gà nguyên con khoảng 2.5 kg.
	<br>
	- Sử dụng công nghệ làm nóng điện trở nhiệt, giúp thực phẩm chín nhanh và đều tất cả các bề mặt.
	</p>
	<h5>Thiết kế sản phẩm</h5>
	<p>
	- Thiết kế tinh tế với vỏ lò làm bằng tôn sơn tĩnh điện, màu đen sang trọng.
	<br>
	- Cửa kính 2 lớp và chịu lực, chịu nhiệt, đảm bảo an toàn trong quá trình sử dụng.
	<br>
	- Bảng điều khiển nút vặn có tiếng Việt, dễ hiểu và dễ dàng thao tác.
	</p>
	<h5>5 chế độ nướng</h5>
	<p>
	- Nướng trên dưới có quạt đối lưu.
	<br>
	- Nướng trên có quạt đối lưu.
	<br>
	- Nướng trên dưới.
	<br>
	- Nướng trên có xiên quay.
	<br>
	- Nướng trên dưới có xiên quay và quạt đối lưu.
	</p>
	<h5>Tiện ích</h5>
	<p>
	- Trang bị 2 thanh dẫn nhiệt trên dưới, giúp thực phẩm được nướng chín đều, thơm ngon, không bị cháy xém.
	<br>
	- Trang bị quạt đối lưu đưa khí nóng luân chuyển khắp khoang lò.
	<br>
	- Nắp kính trong suốt và có đèn trong khoang lò giúp quan sát được thức ăn bên trong lúc đang nấu.
	<br>
	- Lò nướng Sunhouse có báo hiệu bằng âm thanh khi hoàn thành quá trình nấu.
	<br>
	- Xiên nướng quay 360°, giúp thực phẩm chín đều mọi góc độ.
	</p>
	<h5>Phụ kiện</h5>
	<p>
	Bao gồm: khay nướng, khay hứng, vỉ nướng, xiên quay, tay cầm lấy khay/vỉ nướng, tay cầm lấy xiên quay.
	</p>
	<p>
	<b>Lưu ý khi sử dụng lò nướng:</b>
	<br>
	- Không sử dụng hộp nhựa, hộp xốp để đựng thức ăn cho vào lò nướng.
	<br>
	- Sử dụng hộp thủy tinh chuyên dụng để đựng thức ăn vào lò nướng.
	<br>
	- Không để lò nướng gần bếp gas hoặc các vật dễ bắt lửa như rèm cửa, giấy, ...
	<br>
	- Không để gần nơi ẩm ướt như cạnh bồn rửa chén, tránh nguy cơ chập điện.
	<br>
	- Rút phích cắm ra khỏi ổ cắm điện và để lò nguội hoàn toàn trước khi vệ sinh.
	<br>
	- Làm sạch lò bằng khăn ẩm mềm, không lau thanh gia nhiệt theo ý muốn.
	<br>
	- Đọc kỹ hướng dẫn sử dụng trước khi dùng.
	<br>
	<br>
	Lò nướng Sunhouse Mama S32 lít với công suất 1550W, dung tích 40 lít cùng nhiều chế độ nướng, hỗ trợ tối đa cho người dùng trong việc làm bánh, nấu nướng,... tiện lợi và nhanh chóng hơn.
	</p>
' where id = 32
go

update products set [description] =N'
	<h5>Máy xay sinh tố Sunhouse S33 Xanh màu sắc thời trang</h5>
	<h5>Công suất 350W mạnh mẽ giúp xay mịn mọi loại thực phẩm nhanh chóng</h5>
	<h5>Máy trang bị 2 cối xay bằng thuỷ tinh chịu lực, hạn chế bám mùi, dễ dàng vệ sinh sau khi dùng</h5>
	<p>
	- Cối xay sinh tố dung tích 1 lít xay được nhiều thực phẩm cùng lúc. Cối xay nhỏ 0.3 lít có thể dùng để xay tiêu, các loại hạt, gia vị khô, ...
	</p>
	<h5>Máy xay sinh tố đa năng với thiết kế lưỡi dao bằng thép không gỉ, an toàn cho sức khoẻ, sắc bén, bền bỉ</h5>
	<h5>Dễ dàng điều khiển máy xay bằng nút bấm</h5>
	<p>
	Máy xay sinh tố được trang bị 2 tốc độ xay kèm chế độ nhồi (kí hiệu *) giúp nhồi trộn nguyên liệu khi xay.
	<br>
	<br>
	Máy xay sinh tố Sunhouse S33 Xanh thương hiệu Sunhouse uy tín, chất lượng, giá thành phải chăng được nhiều người tiêu dùng lựa chọn.
	</p>
' where id = 33
go

update products set [description] =N'
	<h5>Máy xay sinh tố Toshiba chất liệu nhựa cao cấp không chứa BPA (Bisphenol A) độc hại, sử dụng an toàn sức khỏe</h5>
	<p>
	- Kiểu dáng đơn giản, màu sắc trang nhã, dùng đẹp trong mọi không gian.
	</p>
	<h5>Hoạt động hiệu quả với công suất cao đến 600W, xay nhanh và nhuyễn mịn mọi nguyên liệu bởi lưỡi dao 4 cánh sắc bén bằng thép không gỉ</h5>
	<h5>Xay sinh tố với cối xay bằng nhựa dung tích 1.5 lít, phục vụ nhu cầu sử dụng trong gia đình</h5>
	<p>
	Cối dễ dàng tháo lắp tiện vệ sinh sau mỗi lần dùng.
	</p>
	<h5>Xay thực phẩm khô như: các loại hạt, ngũ cốc, gia vị… với cối xay nhỏ dung tích 200 ml, hỗ trợ tích cực trong sử dụng nhà bếp</h5>
	<h5>Máy xay sinh tố đa năng với điều khiển đơn giản với núm xoay gồm 2 tốc độ xay và 1 chế độ nhồi trộn nguyên liệu</h5>
	<p>Máy có chân đế chống trượt nên vận hành thật chắc chắn trên cả mặt bàn trơn bóng.</p>
	<h5>Kèm thêm nắp phụ dễ châm nguyên liệu khi đang xay, thìa khuấy tiện dụng giúp các món sinh tố thêm sánh mịn và thơm ngon</h5>
	<h5>Chế độ khớp khóa an toàn đảm bảo máy không thể vận hành khi chưa lắp đúng khớp, tránh các rủi ro gây hư hại, chập cháy</h5>
	<p>
	Sản phẩm tự ngắt điện an toàn, ngưng hoạt động khi bị nóng quá tải, thêm an toàn sử dụng.
	<br>
	<br>
	Máy xay sinh tố Toshiba S34 đẹp, tiện dụng, gia dụng hữu ích cho nhu cầu chăm sóc sức khỏe và dinh dưỡng cho gia đình.
	</p>
' where id = 34
go

update products set [description] =N'
	<h5>Máy xay sinh tố Sharp sử dụng xay sinh tố, xay hạt, gia vị, ngũ cốc, ... với 2 cối xay bằng nhựa cao cấp nhẹ bền, kháng vỡ</h5>
	<p>
	- Thiết kế đơn giản, màu sắc hiện đại, đẹp mắt, làm đẹp không gian bếp.
	</p>
	<h5>Cối xay sinh tố dung tích 1.5 lít xay được 3 – 5 ly sinh tố cho 1 lần dùng, dễ dàng tháo lắp và vệ sinh sau khi sử dụng</h5>
	<h5>Cối xay khô 60 gram dùng xay thực phẩm khô như các loại hạt, ngũ cốc, gia vị, ...</h5>
	<p>
	Xay mọi thực phẩm nhanh và nhuyễn mịn nhờ lưỡi dao 4 cánh sắc bén bằng inox 301 và công suất hoạt động đến 500W.
	<br>
	5 tốc độ xay và 1 chế độ nhồi điều khiển bằng núm xoay.
	</p>
	<h5>Máy có chân đế chống trượt giúp máy đứng vững, hạn chế rung lắc khi hoạt động</h5>
	<h5>Máy xay sinh tố chỉ hoạt động khi lắp đúng khớp, chức năng tự ngắt khi quá tải đảm bảo an toàn khi sử dụng và tuổi thọ máy</h5>
	<h5>Dây điện dài 94 cm, có rãnh cuộn dây điện ở mặt đế tiện cất giữ gọn gàng</h5>
	<p>
	<b>Sử dụng máy xay sinh tố an toàn, bền tốt:</b>
	<br>
	- Không xay quá nhiều thực phẩm trong 1 lần dùng, chỉ nên chứa khoảng 2/3 dung tích cối để nguyên liệu được đảo đều và chống tràn khi xay.
	<br>
	- Tháo rời các bộ phận và vệ sinh cối sạch sẽ sau mỗi lần dùng.
	<br>
	- Không để động cơ xay liên tục quá 2 phút, dễ làm nóng dẫn đến tự ngắt. Trong trường hợp thiết bị bị ngắt do nóng quá tải, cần chờ khoảng 15 – 20 phút để có thể sử dụng lại.
	<br><br>
	Máy xay sinh tố Sharp S35 màu sắc trang nhã, chất liệu an toàn, dễ dàng sử dụng, đảm bảo an toàn nguồn điện và tuổi thọ thiết bị.
	</p>
' where id = 35
go

update products set [description] =N'
	<p>
	<b>Máy xay sinh tố Panasonic thiết kế màu trắng sang trọng, công suất 700W, lưỡi dao sắc bén, cùng công nghệ đảo trộn V&M, cho bạn những ly sinh tố thơm ngon, bổ dưỡng hay chế biến những bữa ăn đa dạng từ thịt và cá.</b>
	</p>
	<h5>Thiết kế</h5>
	<p>
	Máy gồm 3 cối xay bằng thủy tinh chịu nhiệt, chịu lực tốt, dễ vệ sinh.
	<br>
	- Cối lớn 1.5 lít xay sinh tố, khoảng 250g đá viên xấp xỉ 8-10g/viên.
	<br>
	- Cối xay thịt 200g xay thực phẩm tươi sống như cá, thịt các loại.
	<br>
	- Cối nhỏ xay được tối đa 50g (đồ khô)/200 ml (đồ ướt) tiện xay các loại hạt, gia vị như tiêu, tỏi, ớt, ...
	</p>
	<h5>Công suất hoạt động, lưỡi dao</h5>
	<p>
	Vận hành với công suất 700W cùng lưỡi dao răng cưa được làm từ thép không gỉ 4 cánh xay nhuyễn, mịn thực phẩm.
	</p>
	<h5>Tốc độ, bảng điều khiển</h5>
	<p>
	- Máy xay sinh tố 2 tốc độ, 2 nút nhồi tiện xay sinh tố, xay hạt, xay thịt, đá và nhồi thực phẩm.
	- Dễ dàng tùy chỉnh bằng nút nhấn, thuận tiện trong quá trình sử dụng.
	</p>
	<h5>Tiện ích, chức năng an toàn</h5>
	<p>
	- Tự ngắt khi quá tải đảm bảo an toàn nguồn điện và thiết bị.
	<br>
	- Khóa an toàn, máy chỉ hoạt động khi lắp đúng khớp.
	<br>
	- Công nghệ đảo trộn V&M cho sinh tố thơm ngon, nhuyễn mịn.
	<br>
	- Chế độ làm sạch nhanh chóng và dễ dàng. 
	<br>
	- Nắp đậy 4 viền chống tràn khi xay. 
	</p>
	<h5>Lưu ý khi sử dụng</h5>
	<p>
	- Máy sẽ không hoạt động khi các chốt khoá trên máy chưa lắp đúng, bạn cần kiểm tra kỹ trước khi khởi động máy.
	<br>
	- Nên cho thực phẩm với lượng vừa phải, cắt nhỏ thực phẩm, tiếp thực phẩm từ từ trong quá trình xay để hạn chế sự cố tắt máy vì quá tải do tắc nghẽn.
	<br>
	- Nên đậy nắp khi xay để thức ăn không văng ra bên ngoài làm mất vệ sinh không gian sử dụng.
	<br>
	- Mỗi lần xay không nên để quá 30 giây để tránh động cơ quá nóng sẽ tự ngắt.
	<br>
	- Nên vệ sinh cối liền sau khi sử dụng để dễ làm sạch các vết bẩn của thức ăn.
	<br>
	- Có thể sử dụng chế độ làm sạch cối "P2" để việc vệ sinh máy được dễ dàng và nhanh chóng hơn.
	<br>
	<br>
	Máy xay sinh tố Panasonic S36  thương hiệu Nhật Bản uy tín, chất liệu cối an toàn, dùng bền tốt, cùng nhiều tiện ích và tính năng an toàn là lựa chọn đúng đắn cho gia đình Việt.
	</p>
' where id = 36
go

update products set [description] =N'
	<h5>Máy xay sinh tố Kangaroo S37 kiểu dáng sang trọng, đẹp mắt với tông màu đen xám</h5>
	<p>
	Với 1 cối xay sinh tố, 1 cối xay thịt và 1 cối xay thực phẩm khô, đáp ứng đủ mọi nhu cầu làm bếp của bạn. Chất liệu cối xay bằng nhựa kháng vỡ, an toàn cho sức khoẻ dễ vệ sinh sau khi dùng. 
	</p>
	<h5>Cối máy xay sinh tố Kangaroo đa năng có dung tích 1 lít kèm lược lọc bã giúp sinh tố xay được mịn, mượt hơn</h5>
	<h5>Cối xay 200 ml khô tiện dụng phù hợp để xay tiêu, gia vị, cà phê, ...</h5>
	<p>
	Công suất máy xay sinh tố 380W mạnh mẽ, cùng lưỡi xay bằng thép không gỉ sắc bén giúp xay mịn mọi loại thực phẩm.
	</p>
	<h5>Cối xay thịt 500 ml phù hợp để xay thịt, cá đã bỏ xương giúp bạn tiết kiệm thời gian hơn khi làm bếp</h5>
	<p>
	<b>Lưu ý:</b> Các nguyên liệu phải được cắt nhỏ và xay 1 lần tầm 50 - 100g để đảm bảo độ bền cho máy. 
	</p>
	<h5>Bảng điều khiển nút vặn dễ sử dụng với 2 tốc độ xay và 1 chế độ xay nhồi trộn nguyên liệu (kí hiệu P)</h5>
	<p>
	Máy xay sinh tố đa năng tiện dụng, giá cả phải chăng xay thực phẩm dễ dàng, nhuyễn mịn, xứng đáng là món đồ gia dụng không thể thiếu trong gian bếp nhà bạn.
	</p>
' where id = 37
go

update products set [description] =N'
	<p>
	<b>Máy xay sinh tố Kangaroo S38 với 5 tốc độ xay, 1 chế độ nhồi cùng công suất 600W mạnh mẽ và lưỡi dao 6 cánh có răng cưa giúp xay nhanh nhuyễn mịn. Sản phẩm đáp ứng tốt nhu cầu xay sinh tố, rau củ, đá nhỏ sử dụng trong gia đình.</b>
	</p>
	<h5>Cối xay máy xay sinh tố Kangaroo KGBL600X</h5>
	<p>
	Sản phẩm có 1 cối dung tích 1.5 lít xay sinh tố, rau củ, đá nhỏ,... bằng thủy tinh an toàn, dễ vệ sinh, hạn chế ám màu và mùi.
	</p>
	<h5>Công suất - Lưỡi dao</h5>
	<p>
	Vận hành với mức công suất tối đa 600W cùng lưỡi dao răng cưa 6 cánh bằng inox 304 an toàn, xay đá nhỏ nhuyễn mịn nhanh chóng.
	</p>
	<h5>Tốc độ - Bảng điều khiển</h5>
	<p>
	- Máy xay sinh tố Kangaroo 5 tốc độ và 1 nút nhồi tiện trộn nguyên liệu, chống tắc nghẽn, xay nhuyễn đều.
	<br>
	- Điều khiển nút xoay dễ dàng tùy chỉnh.
	</p>
	<h5>Các tiện ích và chức năng an toàn</h5>
	<p>
	- Tự ngắt khi quá tải đảm bảo an toàn nguồn điện và thiết bị.
	<br>
	- Chân đế chống trượt hạn chế rung lắc khi đang sử dụng.
	<br>
	- Chỉ hoạt động khi lắp đúng khớp.
	<br>
	<br>
	Máy xay sinh tố Kangaroo S38 vận hành với công suất 600W, lưỡi dao răng cưa 6 cánh có khả năng xay đá nhỏ nhanh chóng, cối thủy tinh an toàn, dễ vệ sinh, hạn chế ám mùi đáp ứng tốt nhu cầu sử dụng trong gia đình.
	</p>
' where id = 38
go

update products set [description] =N'
	<h5>Máy lọc không khí Kangaroo nhỏ gọn, thiết kế sang trọng, mang nét hiện đại và tạo điểm nhấn cho không gian sử dụng</h5>
	<h5>Lọc sạch hiệu quả với hệ lọc 3 lớp gồm: màng lọc thô, màng lọc HEPA và màng lọc than hoạt tính</h5>
	<p>
	- Màng lọc thô lọc bụi kích thước lớn.
	<br>
	- Màng lọc HEPA 12 cấp loại bỏ đến 99.9% các tạp chất có trong không khí với kích thước lọc siêu nhỏ đến 0.3 micron.
	<br>
	- Màng lọc than hoạt tính giúp hút ẩm, khử mùi ẩm mốc hiệu quả cho không khí, trả lại môi trường không khí sạch trong thoáng đãng dễ chịu. Than hoạt tính trên máy lọc không khí Kangaroo được hoạt hóa giúp cấu trúc của carbon trở nên xốp, xơ rỗng với rất nhiều lỗ nhỏ li ti. Điều này giúp than hoạt tính có khối lượng riêng nhẹ và diện tích bề mặt tiếp xúc lớn hơn. Do đó, than hoạt tính có khả năng bám hút và hấp thụ mạnh mẽ với các chất khác như một chiếc nam châm, đồng thời hút ẩm xử lý mùi và hút độ ẩm (dưới 80%).
	<h5>Độ ồn hoạt động thấp ≤ 35 dB, có chế độ hẹn giờ giúp người dùng thoải mái sử dụng thiết bị kể cả ban ngày hay ban đêm</h5>
	<h5>Công suất 50W phù hợp lọc không khí diện tích 30 - 40m2</h5>
	<p>
	Với chế độ Auto tự điều chỉnh công suất theo chất lượng không khí, giúp cho việc sử dụng máy lọc không khí tiết kiệm điện hiệu quả hơn.
	</p>
	<h5>Diệt khuẩn bằng đèn UV phát tia cực tím bức xạ để tiêu diệt vi khuẩn, virus, nấm mốc nhưng đảm bảo an toàn với sức khoẻ người dùng</h5>
	<h5>Máy lọc không khí tạo ion âm Ionizer 1.000.000 pcs/cm3</h5>
	<p>
	Giúp bổ sung các ion âm tự nhiên hoạt động trong không khí, trung hòa các chất ô nhiễm, đem lại bầu không khí trong lành hơn, bảo vệ sức khỏe tốt hơn.
	</p>
	<h5>Bảng điều khiển cảm ứng có màn hình hiển thị thao tác nhạy bén, dễ dàng quan sát</h5>
	<p>
	Chế độ hiển thị chỉ số bụi mịn PM2.5 cho người dùng đánh giá tốt hơn chất lượng không khí và tính an toàn của môi trường sống xung quanh máy lọc.
	<br>
	Máy có cảnh báo thay màng lọc hỗ trợ người dùng nhận biết thay thế đúng thời điểm, nâng cao chất lượng sử dụng thiết bị.
	</p>
	<h5>Cảm biến bụi với hiển thị đèn báo thay đổi màu sắc</h5>
	<p>
	Thông báo chất lượng không khí của môi trường sử dụng thiết bị, giúp người dùng làm chủ tốt hơn thời gian và chế độ lọc khi dùng máy lọc không khí.
	</p>
	<h5>Remote đi kèm, điều khiển từ xa tiện lợi</h5>
	<p>
	Máy lọc không khí Kangaroo S39 sản phẩm giúp gia tăng chất lượng sống cho không gian gia đình.
	</p>
' where id = 39
go

update products set [description] =N'
	<h5>Máy lọc không khí với thiết kế tông màu đen bóng tinh tế, tạo điểm nhấn hiện đại, sang trọng phù hợp cho diện tích dưới 62 m²</h5>
	<h5>Điều khiển thông minh bằng điện thoại với công nghệ AIoT với app Sharp Air</h5>
	<p>
	Bạn có thể chủ động theo dõi chế độ vận hành trong phòng, hiển thị chất lượng không khí trong phòng và kiểm tra thời gian tối ưu thay bộ lọc, giúp bạn có thể thao tác từ xa nhờ app Sharp Air được cài đặt trên điện thoại dễ dàng.
	</p>
	<h5>Tự động lọc bụi, khử mùi nhanh chóng nhờ hệ thống cảm biến thông minh</h5>
	<p>
	Máy tự động tăng công suất lọc khi phát hiện bụi mịn PM2.5, mùi hôi trong không khí (thuốc lá, vật nuôi, amoniac).
	<br>
	Ngoài ra, hệ thống còn có thể phát hiện ánh sáng xung quanh đã tắt để vận hành chế độ ngủ làm máy hoạt động êm ái hơn giúp người dùng ngủ ngon giấc.
	</p>
	<h5>Thuận tiện theo dõi chất lượng không khí dựa theo màu sắc đèn báo</h5>
	<h5>Tiết kiệm điện năng tối ưu và hoạt động êm ái với công nghệ Inverter</h5>
	<p>
	Máy lọc không khí Sharp còn được trang bị công nghệ Inverter giúp giúp máy hoạt động êm ái, tiết kiệm điện, tối ưu chi phí của gia đình.
	<br>
	Công nghệ inverter tiết kiệm điện và giúp máy vận hành êm ái. Với lượng gió thổi ra: Thấp 60 m3/h - Trung bình 288 m3/h - Cao 480 m3/h máy sẽ có độ ồn tương ứng là 15 dB, 45 dB, 47 dB thì với độ ồn cao nhất thì máy cũng chỉ có âm thanh như tiếng trò chuyện thông thường.
	</p>
	<h5>Lọc nhanh tối đa không khí với chế độ Haze</h5>
	<p>
	Khi chế độ Haze được kích hoạt, máy lọc sẽ vận hành ở tốc độ cao nhất trong 60 phút đầu, sau đó luân phiên vận hành giữa 2 cấp độ thấp và cao trong 20 phút, mang đến khả năng lọc không khí mạnh mẽ, nhanh chóng.
	</p>
	<h5>Tiêu diệt nấm mốc, vi khuẩn, mùi hôi nhờ công nghệ Plasmacluster ion với 25000 hạt ion/cm3</h5>
	<p>
	Không còn phải lo lắng về vi khuẩn, nấm mốc, mùi hôi sâu trong các ngóc ngách của phòng với chế độ PCI Spot. Khi kích hoạt chế độ này lượng lớn Plasmacluster Ion sẽ được tạo ra trong không khí, quá trình tiêu diệt vi khuẩn sẽ được đẩy mạnh, nấm mốc và loại bỏ mùi hôi đến các ngóc ngách trong phòng, tạo không gian trong lành nhất cho căn phòng của bạn.
	</p>
	<h5>Tiện lợi với chức năng tự khởi động lại khi có điện</h5>
	<p>
	Máy lọc không khí Sharp S40 nổi tiếng Nhật Bản, sản xuất tại Thái Lan với lượng ion phát ra lên đến 25000 hạt ion/cm3 sẽ mang lại bầu không khí trong sạch bảo vệ sức khoẻ cho cả gia đình bạn.
	</p>
' where id = 40
go

update products set [description] =N'
	<h5>Máy lọc không khí Sunhouse lọc sạch không khí hiệu quả và lọc được bụi PM 2.5</h5>
	<p>
	Máy lọc không khí sử dụng kết hợp giữa hệ thống màng lọc cao cấp, bộ cảm biến bụi và mùi theo thực tế chất lượng không khí cùng công nghệ ion âm hiện đại giúp tăng cường hiệu quả lọc. Nhờ thế mà đảm bảo lọc sạch được bụi bẩn, khói mùi, các tác nhân gây dị ứng và cả bụi mịn PM 2.5 trong nhà.
	</p>
	<h5>Hệ thống 3 lớp lọc mạnh mẽ, bao gồm:</h5>
	<p>
	- Màng lọc thô: Kết cấu xen kẽ đa lớp, ngăn chặn bụi bẩn và tạp chất kích thước lớn như bông, tóc, sợi vải,… Phân hủy khí và mùi trong không khí như formaldehyde, rượu và ammoniac đồng thời diệt virus và vi khuẩn có hại.
	<br>
	- Màng lọc HEPA 11: Lọc sạch những tác nhân gây dị ứng, bụi mịn PM 2.5 đến 99% và kể các các dạng bụi mịn siêu nhỏ với kích thước 0.05 micron.
	<br>
	- Màng lọc than hoạt tính lưới sợi: Lọc được các hợp chất hữu cơ dễ bay hơi và giữ lại các mùi hôi gây khó chịu, khói thuốc lá và các chất khí độc hại.
	</p>
	<h5>Máy sở hữu tốc độ phân phối không khí sạch CADR=350 m³/h, đặc biệt phù hợp với không gian có diện tích từ 30 - 40m²</h5>
	<h5>Đèn báo hiển thị chất lượng không khí theo chuẩn AQI, giúp người dùng dễ nắm chất lượng không khí nơi mình đang ở</h5>
	<p>
	Dễ thao tác sử dụng bằng bảng điều khiển cảm ứng với 3 chế độ vận hành và 3 tốc độ quạt.
	<br>
	+ Chế độ khử trùng và chế độ anion giúp máy lọc sạch bụi bẩn và mang lại bầu không khí trong lành.
	<br>
	+ Chế độ ngủ: hoạt động với độ ồn thấp nhất, đảm bảo sự yên tĩnh cho giấc ngủ sâu.
	</p>
	<h5>Được thiết kế theo hướng tối giản với màu trắng chủ đạo, tạo sự trang nhã thanh lịch cho không gian sử dụng</h5>
	<p>
	Thân máy làm từ nhựa ABS bền tốt, dễ vệ sinh lau chùi.
	</p>
	<h5>Khi máy hoạt động, độ ồn tạo ra nhỏ từ 38 - 44.5 dB, đảm bảo không gây khó chịu</h5>
	<p>Độ ồn này như tiếng nhạc nhẹ, du dương sẽ không làm ảnh hưởng đến các công việc khác như xem tivi, đọc sách, nghe nhạc, ...</p>
	<h5>Chức năng hẹn giờ tiện dụng, hỗ trợ người dùng sắp xếp thời gian cho các công việc khác hiệu quả</h5>
	<h5>Máy lọc không khí được trang bị cảnh báo thay màng lọc thông minh</h5>
	<p>
	Máy lọc không khí Sunhouse S41 có thiết kế tối giản cùng nhiều chức năng thông minh giúp lọc sạch không khí, đem lại không gian sống lành mạnh, thoáng mát, tăng cường chất lượng cuộc sống cho gia đình bạn.
	</p>
' where id = 41
go

update products set [description] =N'
	<h5>Máy lọc không khí Samsung kết cấu vững chắc, màu sắc trang nhã, có bánh xe di chuyển linh hoạt</h5>
	<p>
	Máy thiết kế có thể đặt sát tường, tiện sử dụng và bảo quản.
	</p>
	<h5>Máy lọc không khí có công suất 60W cho phạm vi lọc không khí tối ưu đến 60m2, thích hợp dùng trong phòng khách, phòng ngủ, phòng bếp, ...</h5>
	<h5>Bộ lọc 3 lớp: màng lọc thô, màng lọc than hoạt tính, màng lọc HEPA</h5>
	<p>
	Bộ lọc gồm màng lọc bụi thô có thể giặt được, xử lý tốt bụi bẩn, phấn hoa, vảy thú cưng, màng lọc than hoạt tính khử mùi hôi, mùi khói thuốc lá, khí gas độc hại và màng lọc HEPA loại bỏ đến 99.9% vi khuẩn, bụi siêu mịn PM0.3, PM2.5, PM1.0.
	</p>
	<h5>Màn hình cảm ứng hiện đại.</h5>
	<p>
	Thiết kế điều khiển cảm ứng với màn hình hiển thị sắc nét điều chỉnh các chức năng dễ dàng. Cảm ứng độ bụi hiện đại laser PM phát hiện chính xác bụi đến các hạt nhỏ hơn đến 1.0 micromet, đèn hiển thị chất lượng không khí bằng số và 4 chỉ số màu sắc cho bạn theo dõi chất lượng không khí tiện lợi, sử dụng máy tiện lợi hơn.
	</p>
	<h5>Chế độ tự động, tự điều chỉnh công suất, tốc độ quạt sau khi đo lường mức độ ô nhiễm của không khí cho khả năng lọc không khí tối ưu. Chế độ ngủ thổi gió nhẹ nhàng, tắt màn hình hiển thị cho bạn giấc ngủ ngon hơn.</h5>
	<h5>Kết nối ứng dụng SmartThings điều khiển máy lọc không khí từ xa dễ dàng, linh hoạt</h5>
	<p>
	<b>Sử dụng máy lọc không khí đúng cách:</b>
	<br>
	- Không che chắn quá nhiều đồ vật xung quanh máy, không đặt gần vật dễ cháy nổ.
	<br>
	- Di chuyển nhẹ nhàng, không kéo đẩy mạnh tay.
	<br>
	- Vệ sinh màng lọc, bảo trì định kỳ để máy hoạt động tốt hơn.
	<br>
	<br>
	Máy lọc không khí Samsung S42, sản phẩm hiện đại tiện dụng, thiết kế đẹp, chức năng đa dạng, lọc không khí hiệu quả, mang lại nhiều lợi ích tuyệt vời cho sức khỏe gia đình.
	</p>
' where id = 42
go

update products set [description] =N'
	<p>
	<b>Máy lọc không khí LG PuriCare AeroTower màu xanh lá thiết kế độc đáo, màu sắc trang nhã, phù hợp với nhiều không gian, lọc được nhiều loại bụi mịn với bộ lọc 3 lớp: màng lọc thô, màng lọc TRUE HEPA và màng lọc than hoạt tính giúp không khí được lọc sạch hơn trong phạm vi dưới 76m2, điều khiển từ xa thông qua ứng dụng LG ThinQ và remote, cảm biến bụi, nhiệt độ và độ ẩm giúp bạn tiện theo dõi tình trạng không khí, độ ẩm và nhiệt độ trong nhà, cảm biến chất lượng không khí thông qua 4 màu sắc khác nhau giúp bạn tùy chọn được chế độ lọc phù hợp.</b>
	</p>
	<h5>Thiết kế</h5>
	<p>
	- Máy lọc không khí LG PuriCare AeroTower màu xanh lá thiết kế tối ưu và hướng đến người dùng với kiểu thiết kế Aerodynamic - lấy cảm hứng từ thung lũng, tạo ra làn gió tự nhiên với vẻ ngoài tinh tế và hiện đại mang đến cho ngôi nhà một nét riêng, thích hợp với nhiều không gian: phòng khách, phòng ngủ,... 
	<br>
	- Ngoài ra bạn có thể thiết đặt vòng quay của sản phẩm với các góc 45°, 60°, 90°, 140° hoặc dừng giúp làm mát khắp không gian trong phòng.
	<br>
	- Lọc sạch không khí và làm mát hiệu quả với không gian lớn dưới 76m².
	</p>
	<h5>Thông tin bộ lọc - Loại bụi lọc được</h5>
	<p>
	- Bộ lọc 3 lớp bao gồm màng lọc thô, màng lọc TRUE HEPA và màng lọc than hoạt tính:
	<br>
	+ Màng lọc thô: lọc được các hạt có kích thước lớn trong không khí như bụi bẩn, lông thú cưng,...
	<br>
	+ Màng lọc TRUE HEPA: loại bỏ bụi mịn có kích thước nhỏ đến 0.3 micromet trong không khí như khói, phấn hoa, vi trùng,...
	<br>
	+ Màng lọc than hoạt tính: là một bộ lọc khử mùi giúp loại bỏ các mùi: khói thuốc lá, chất thải thực phẩm, lông động vật và các chất hóa học trong không khí.
	<br>
	- Lọc được bụi mịn PM10, PM2.5, PM1.0, PM0.3 giúp bạn có một bầu không khí trong lành hơn.
	</p>
	<h5>Công nghệ và khả năng cảm biến thông minh</h5>
	<p>
	- Công nghệ UVnano™ loại bỏ 99.9% vi khuẩn từ không khí bám trên cánh quạt như một bước bảo vệ tăng cường. Tỉ lệ lọc được bụi mịn PM0.3 lên đến 99.97% giúp bạn có một bầu không khí trong lành và tươi mới hơn.
	<br>
	- Với động cơ Inverter giúp tiết kiệm điện bên cạnh đó bạn có thể tận hưởng không khí đã được lọc sạch trong không gian yên tĩnh, độ ồn thấp khi ở chế độ ngủ (Sleep) chỉ khoảng 23 dB mà vẫn lọc sạch được không khí. 
	<br>
	- Màn hình LCD thông minh hiển thị mức độ hạt bụi trong nhà theo thời gian thực với cảm biến PM1.0 và cảm biến bụi, nhiệt độ và độ ẩm.
	<br>
	- Cảm biến bụi, nhiệt độ và độ ẩm. 
	<br>
	- Dễ dàng kiểm tra chất lượng không khí từ xa hoặc vào ban đêm với đèn hiển thị chất lượng không khí bằng các màu sắc khác nhau:
	<br>
	+ Xanh lá: không khí sạch.
	<br>
	+ Vàng: không khi ở mức độ sạch vừa phải.
	<br>
	+ Cam: không khí ô nhiễm ở mức thấp.
	<br>
	+ Đỏ: không khí ô nhiễm ở mức nghiêm trọng.
	</p>
	<p>
	Máy lọc không khí LG S43 màu xanh lá sở hữu nhiều tính năng hiện đại: cảm biến chất lượng không khí, công suất 50W lọc sạch hiệu quả trong phạm vi dưới 76m2, công nghệ UVnano™ giúp khử khuẩn và lọc sạch không khí hiệu quả vượt trội, hoạt động êm ái với động cơ Inverter, 10 mức độ gió tùy chỉnh theo nhu cầu sử dụng,... chắc hẳn sẽ là một lựa chọn đáng cân nhắc để mang lại bầu không khí trong lành cho căn nhà của bạn.
	</p>
' where id = 43
go

update products set [description] =N'
	<h5>Máy lọc không khí Cuckoo kiểu dáng nhỏ gọn, trọng lượng nhẹ 5.9 kg, công suất 50W phù hợp với diện tích 31.2m2</h5>
	<p>
	Tiện lợi di chuyển, dễ dàng mang đi và đặt gọn mọi nơi mọi lúc như ô tô, nôi em bé, bàn làm việc.
	<br>
	Công suất hoạt động mạnh mẽ lọc sạch gần 99.97% bụi bẩn, bụi mịn, vi khuẩn, nấm mốc hiệu quả.	
	</p>
	<h5>Mang lại bầu không khí trong lành, tinh khiết với màng lọc HEPA, màng lọc thô và màng lọc than hoạt tính</h5>
	<p>
	Giúp dễ dàng loại bỏ bụi mịn PM 2.5 khuẩn, virus, khử mùi nấm mốc, mang đến không gian sống trong lành mang lại cho cả gia đình không gian sạch đẹp và trong lành.
	<br>
	- Màng lọc HEPA loại bỏ được các vật chất gây ô nhiễm, bụi mịn siêu nhỏ có kích cỡ 0.3 micromet (µm), các tác nhân gây hen suyễn, dị ứng có trong không khí.
	<br>
	- Màng lọc thô giúp thu giữ và loại bỏ những bụi bẩn có kích thước lớn như bụi thô, lông tóc, sợi vải, ...
	<br>
	- Màng lọc than hoạt tính (carbon) khử mùi, hấp thụ mùi độc hại có nguồn gốc từ chất hữu cơ bay hơi gây ra bao gồm: mùi thuốc lá, nấm mốc, nhựa mới, xăng xe, ...
	</p>
	<h5>Hệ thống cảnh báo chất lượng không khí bằng đèn LED</h5>
	<p>
	Máy tích hợp cảm biến chất lượng không khí và đèn LED  báo hiệu chất lượng không khí trên máy bằng 3 màu sắc cho biết được chất lượng không khí hiện có trong nhà bạn đang ở tình trạng nào.
	<br>
	- Đèn màu xanh lá cây: Không khí đang rất là trong lành.
	<br>
	- Đèn màu cam: Không khí đang ở trong trạng thái ô nhiễm trung bình.
	<br>
	- Đèn màu đỏ: Không khí trong nhà đang ô nhiễm rất là nặng.
	<br>
	Đèn báo này được báo hiệu 1 cách chính xác bởi bộ cảm biến được trang bị phía sau.
	</p>
	<h5>Bảng điều khiển hẹn giờ tắt máy 1 giờ - 4 giờ - 8 giờ</h5>
	<p>
	Máy lọc không khí đặt thời gian tắt thuận tiện, dễ dàng cho người dùng, sau khi hết thời gian cài đặt máy sẽ tự động tắt mà bạn không cần thao tác tắt thủ công nữa.
	</p>
	<h5>Chế độ Turbo cho hiệu quả lọc sạch không khí nhanh chóng, hiệu quả</h5>
	<p>
	Công suất của chế độ Turbo hoạt động vô cùng mạnh mẽ giúp lọc sạch nhanh các tác nhân gây ô nhiễm không khí và gây hại cho sức khỏe.
	<br>
	<br>
	Máy lọc không khí Cuckoo S44 thiết kế sang trọng, bền bỉ, lọc không khí tối ưu, chất lượng cao, là sự lựa chọn đáng tin cậy cho gia đình bạn.
	</p>
' where id = 44
go

update products set [description] =N'
	<h5>Lực hút mạnh mẽ 4200 Pa với động cơ Digital inverter, tối ưu luồng khí hút bằng cánh quạt siêu âm</h5>
	<p>
	Bên cạnh đó, robot hút bụi Samsung còn có tích hợp chức năng thông minh Power Control giúp nhận diện bề mặt và lượng bụi, tự động điều chỉnh công suất hút phù hợp để làm sạch hiệu quả hơn. 	
	</p>
	<h5>Dùng pin sạc Lithium-ion cho thời gian sạc khoảng 4 giờ, sử dụng khoảng 1.5 giờ</h5>
	<h5>Bộ lọc đa lớp hiệu quả loại bỏ tới 99.999% bụi mịn PM 1.0 và các tác nhân gây dị ứng</h5>
	<p>Đảm bảo không khí thải ra là khí sạch trong lành, bảo vệ sức khỏe gia đình.</p>
	<h5>Robot hút bụi tự động thiết lập bản đồ nhà 3D với cảm biến thông minh LiDAR</h5>
	<p>
	Cảm biến dùng laser quét 360° không gian cần làm sạch, phân tích và ghi nhận khoảng cách, chiều sâu  tường nhà rồi tính toán vị trí các vật cản chính xác, tự động tạo bản đồ 3D kết hợp Smart Driving di chuyển thông minh tối ưu đường đi giúp tiết kiệm thời gian dọn dẹp, làm sạch hiệu quả, toàn diện. Lưu được 1 bản đồ bao gồm lên đến 15 phòng và mỗi phòng tối đa 33m x 33m = 1089m2. Lưu ý, nếu có thay đổi vị trí của trạm làm sạch Clean Station hoặc thay đổi 1 góc hơn 45 độ hoặc thay đổi Samsung Account, bạn phải tạo lại bản đồ mới.
	</p>
	<h5>Có bộ chổi bạc tĩnh điện tích hợp bộ cắt tự cắt nhỏ lông động vật nuôi, tóc không gây kẹt động cơ</h5>
	<p>
	Bộ chổi hút mềm chất liệu vải dệt có thành phần bạc chốt tĩnh điện loại bỏ bụi bẩn từ mặt thảm, sàn cứng đến kẽ hở trên mặt sàn. 
	</p>
	<h5>Trạm làm sạch Clean Station tự động làm sạch hộp chứa bụi sau 1 - 3 tháng</h5>
	<p>
	Sau khi hoàn thành việc hút bụi, robot sẽ tự động quay lại trạm làm sạch để loại bỏ bụi bẩn thông qua công nghệ Air Pulse. Đồng thời Clean Station còn là trạm sạc bổ sung năng lượng cho Jet Bot+, tự sạc phục hồi năng lượng cho chính nó. 
	</p>
	<h5>Hộp chứa bụi của robot dung tích 0.3 lít, túi chứa bụi của trạm sạc là 2.5 lít</h5>
	<p>
	Thiết kế hộp và túi chứa bụi dễ dàng tháo lắp, bạn có thể rửa hộp chứa bụi bằng nước còn túi chứa bụi khi đầy, bạn có thể vứt bỏ túi (liên hệ bộ phận chăm sóc khách hàng của Samsung để mua túi mới).
	</p>
	<h5>Dễ dàng điều khiển bằng giọng nói tiếng Việt với trợ lý ảo Google Assistant</h5>
	<p>
	Samsung VR30T85513W/SV nhận diện giọng nói cho phép bạn chỉ định khu vực cần vệ sinh, ra lệnh làm sạch hộp chứa bụi, sạc pin và nhiều hơn thế nữa bằng ngôn ngữ tiếng Việt linh hoạt cùng Google Assistant hoặc dùng với Samsung Bixby, Amazon Alexa có hỗ trợ tiếng Anh.
	</p>
	<h5>Điều khiển từ xa bằng smartphone với ứng dụng SmartThings thông qua kết nối wifi</h5>
	<p>
	Nếu bạn không có mặt tại nhà mà vẫn muốn robot bắt đầu dọn dẹp có thể cài đặt SmartThings trên điện thoại và thực hiện các lệnh bạn muốn như cài đặt khu vực dọn dẹp, đặt vùng cấm ảo để ngăn thiết bị xâm nhập, báo cáo làm sạch trực tiếp cho bạn tiện theo dõi, ...
	</p>
	<h5>Thiết kế nhỏ gọn, màu trắng tươi sáng, tạo điểm nhấn cho mọi không gian sử dụng</h5>
	<p>
	<b>Lưu ý khi sử dụng:</b>
	<br>
	- Nếu công tắc nguồn bị tắt, robot sẽ không thể sạc pin ngay cả khi đã được đặt vào Clean Station.
	<br>
	- Không đặt ngón tay của bạn vào vị trí cảm biến LiDAR đang hoạt động vì ngón tay của bạn có thể bị thương.
	<br>
	- Không nhìn vào bộ phận truyền phát (tia laser) của cảm biến LiDAR đang hoạt động theo chiều ngang.
	<br>
	- Di chuyển robot nhẹ nhàng, không để máy bị rơi.
	<br>
	- Không tự ý tháo rời hay sửa chữa robot, chỉ kỹ thuật viên có chứng nhận mới phù hợp để thực hiện.
	<br>
	<br>
	Robot hút bụi Samsung S45 thiết kế nhỏ gọn, cho lực hút mạnh mẽ 4200 Pa với động cơ Digital inverter, tự động thiết lập bản đồ nhà 3D với cảm biến thông minh LiDAR, bộ lọc đa lớp hiệu quả loại bỏ tới 99.999% bụi mịn PM 1.0, điều khiển linh hoạt bằng giọng nói, smartphone, lựa chọn hoàn hảo cho mọi căn nhà. 
	</p>
' where id = 45
go


update products set [description] =N'
	<h5>Tạo ra lực hút mạnh vượt trội nhờ công nghệ hút đa lốc xoáy Jet Cyclone</h5>
	<p>
	Samsung VS15A6031R1/SV trang bị hệ thống hút đa lốc xoáy Jet Cyclone tạo ra lực hút mạnh vượt trội qua 9 trục hút xoáy và 27 cửa hút gió, giảm thiểu lực hút hao hụt. Công nghệ Jet Cyclone còn có tác dụng lọc bụi mịn hiệu quả, trả lại không khí sạch cho ngôi nhà bạn tối ưu.
	</p>
	<h5>Hệ thống lọc đa lớp với bộ lọc HEPA lọc sạch đến 99.999% bụi mịn 0.3 nm</h5>
	<p>
	Trong khi luồng xoáy chính và bộ lọc lưới kim loại giúp lọc và giữ các lại các hạt bụi có kích thước trung và lớn thì hệ thống hút đa lốc xoáy Jet Cyclone và bộ vi lọc giúp loại bỏ các hạt bụi nhỏ.
	<br>
	Cuối cùng, bộ lọc bụi siêu mịn giúp lọc 99.999% bụi mịn (kích thước từ 0.5 đến 4.2 µm) và các tác nhân gây dị ứng, đảm bảo không khí xả ra từ máy là không khí sạch hoàn hảo.
	</p>
	<h5>Thiết kế sạc linh hoạt nhờ trạm sạc 2 trong 1</h5>
	<p>
	Bạn có thể gắn trạm sạc lên tường để tiết kiệm không gian, hoặc sử dụng như một trạm sạc rời bằng cách tháo pin và sạc tại mọi nơi bạn muốn.
	</p>
	<h5>Chổi hút Jet Fit Brush hút sạch bụi mịn trên thảm dễ dàng như hút trên sàn cứng</h5>
	<p>
	Thiết kế chổi xoay 180 độ tiếp cận linh hoạt mọi ngóc ngách, đầu chổi dễ tháo rời để vệ sinh và bảo quản trong 1 nút bấm.
	</p>
	<h5>Động cơ Digital Inverter, công suất hoạt động 410W với lực hút mạnh tới 150W</h5>
	<p>
	Digital Inverter mạnh mẽ tối ưu luồng khí bằng cánh quạt siêu âm, chịu tải điện năng đầu vào lớn, duy trì công suất hút 150W, giúp máy hoạt động hiệu quả trên nhiều bề mặt khác nhau để làm sạch tốt từ sàn cứng đến mặt thảm, nệm,…
	</p>
	<h5>Máy hút bụi Samsung sử dụng pin sạc 2000 mAh, thời gian sử dụng lên đến 40 phút sau khi sạc đầy trong 4.5 giờ</h5>
	<p>
	Khi hết pin, có thể tháo rời và thay pin dự phòng (bán rời) để tiếp tục chu trình hút đến 80 phút. Sản phẩm dùng bền bỉ, bảo toàn tới 70% hiệu suất ban đầu sau 500 chu trình hút.
	</p>
	<h5>Sử dụng hộp chứa bụi, dung tích 0.8 lít dễ tháo rời, vệ sinh, đổ bụi linh hoạt, có thể rửa được</h5>
	<h5>Kiểu dáng gọn nhẹ, cầm tay làm sạch nhà cửa thuận tiện</h5>
	<p>
	Thân máy hút bụi có khối lượng 2.3 kg, nhẹ hơn 21% so với máy hút bụi Samsung thông thường giúp giảm sức nặng lên cổ tay và thuận tiện di chuyển khắp mọi nơi trong nhà.
	</p>
	<h5>Máy hút bụi cầm tay làm sạch hiệu quả mọi ngóc ngách nhờ tích hợp nhiều đầu hút</h5>
	<p>
	Chổi hút Jet Fit Brush giúp làm sạch sàn, thảm, đầu hút khe hẹp (crevice) vệ sinh các đường rãnh cửa sổ, khe tường còn đầu hút bụi lông mềm - đầu hút có bàn chải (dusting) loại bỏ bụi trên ga, nệm, mọi vị trí trong nhà sẽ dễ dàng được làm sạch hơn.
	</p>
	<p>
	<b>Những lưu ý khi vệ sinh bộ lọc HEPA trên máy hút bụi:</b>
	<br>
	- Tháo màng lọc nhẹ nhàng từ máy hút bụi ra ngoài.
	<br>
	- Dùng chổi quét bụi lông mềm hoặc máy hút bụi mini để loại bỏ bụi bẩn bám vào màng lọc.
	<br>
	- Rửa màng lọc dưới vòi nước chảy nhẹ, tránh ngâm lâu trong nước, dùng nước nóng để tẩy rửa làm giảm tuổi thọ của bộ lọc.
	<br>
	- Sau khi vệ sinh thì cần phơi khô màng lọc ngoài nắng khoảng 1 đến 4 tiếng, tránh không khí ẩm ướt khiến bộ lọc vừa lâu khô, vừa dễ sinh ẩm mốc.
	<br>
	<br>
	Máy hút bụi cầm tay Samsung S46 hiện đại, gọn nhẹ, sử dụng linh hoạt, đa năng, mang đến giải pháp vệ sinh hiệu quả cho mọi vị trí trong ngôi nhà.
	</p>
' where id = 46
go

update products set [description] =N'
	<h5>Máy hút bụi cầm tay thiết kế nhỏ gọn, dễ dàng tháo lắp, di chuyển và sử dụng bất cứ đâu nhà ở, công ty,...</h5>
	<h5>Thiết kế hộp chứa bụi trong suốt với dung tích 0.4 lít, dễ quan sát lượng bụi bên trong, tiện tháo lắp đổ bụi, làm sạch hiệu quả</h5>
	<h5>Philips FC6728 trang bị 3 loại đầu hút: đầu hút sàn, đầu hút bàn chải, đầu lau sàn hỗ trợ làm sạch nhiều khu vực khác nhau</h5>
	<p>
	Máy được trang bị tay cầm có thể tháo gỡ dễ dàng, phụ kiện bàn chải được gắn sẵn trong ống giúp quá trình làm sạch trần nhà và ngăn kệ trở nên thuận tiện hơn.
	</p>
	<h5>Pin Lithium - ion 21.6V cho thời gian làm sử dụng lên tới 50 phút</h5>
	<p>
	Philips S47 trang bị pin Lithium - ion 21.6V hiệu suất cao cung cấp thời gian chạy lên tới 50 phút ở chế độ thường và 22 phút ở chế độ tăng cường trước khi cần sạc lại.
	</p>
	<h5>Máy hút bụi Philips, thu gom tới 98% bụi bẩn trong 1 lần đẩy</h5>
	<p>
	Máy sở hữu đầu hút xoay 180° với lực hút mạnh, máy có thể thu gom bụi bẩn chính xác lên đến 98% trong chỉ 1 lần đẩy trên tất cả các loại sàn, kể cả những chỗ khó tiếp cận.
	</p>
	<h5>Động cơ cao cấp, hút bụi với hiệu quả tối ưu</h5>
	<p>
	Công nghệ PowerCyclone 7 tách bụi khỏi không khí ngay tức thì, giúp duy trì hiệu suất mạnh mẽ trong thời gian lâu hơn.
	<br>
	Động cơ PowerBlade được thiết kế cho tốc độ không khí cao, giúp hút mạnh và chính xác mọi bụi bẩn.
	</p>
	<h5>Máy hút bụi dùng bộ lọc 3 lớp lọc thải tốt đến 99.9% bụi bẩn, vi khuẩn, trả lại không khí sạch thoáng cho không gian dùng</h5>
	<p>
	Bộ lọc của máy hút bụi Philips có thể rửa giúp gia tăng hiệu quả lọc thải, cho tuổi thọ lâu hơn, tiết kiệm chi phí thay thế.
	</p>
	<p>
	<b>Sử dụng máy hút bụi bền lâu: </b>
	<br>
	- Không dùng máy trên mặt sàn hay bề mặt ẩm ướt.
	<br>
	- Không để bụi đầy quá 2/3 dung tích hộp chứa bụi.
	<br>
	- Tránh để trẻ nhỏ sử dụng máy hút bụi ngoài tầm kiểm soát của người lớn.
	<br>
	Máy hút bụi Philips S47 sản phẩm hiện đại nhỏ gọn, tiện lợi cho sử dụng gia đình, giúp cho việc vệ sinh trở nên thật nhanh chóng và linh hoạt.
	</p>
' where id = 47
go

update products set [description] =N'
	<h5>Máy hút bụi không dây Panasonic với khối lượng chỉ 1.6 kg nhẹ nhàng, dễ dàng di chuyển vệ sinh bằng một tay</h5>
	<p>
	Thuận tiện hút bụi tại các vị trí cao như cửa sổ, giá sách mà không gây cảm giác nặng nề với khối lượng 1.6 kg (tương đương 1 chai nước 1.5 lít). Đồng thời thiết kế cầm tay không dây cũng giúp dọn dẹp các khu vực riêng biệt như cầu thang, nội thất ô tô một cách dễ dàng.
	</p>
	<h5>Máy hút bụi Panasonic hút sạch bụi bẩn với công suất hút 100W, có thể sử dụng từ 6 - 20 phút, sạc đầy trong 3.5 giờ</h5>
	<p>
	Công suất hút 100W nhẹ nhàng không làm trầy xước thảm hay sàn nhà mà vẫn có thể hút sạch triệt để, ngay cả với các loại bụi không thể nhìn thấy bằng mắt thường.
	<br>
	Máy có công suất hoạt động 275W (công suất thể hiện mức độ tiêu thụ điện năng) tiết kiệm điện khi sử dụng. Độ ồn ở mức 80 dB tương đương tiếng chiếc xe máy đang chạy, nằm trong ngưỡng mà tai có thể nghe được). 
	</p>
	<h5>Hộp chứa bụi dung tích 0.3 lít phù hợp dùng làm vệ sinh cho phòng ngủ, phòng khách</h5>
	<h5>Máy hút bụi với trang bị chức năng cảm biến phát hiện bụi, giúp làm sạch toàn diện ngôi nhà của bạn</h5>
	<p>
	Thiết kế đèn báo được lắp đặt trên ống hút bụi, sẽ phát sáng khi còn bụi chạy qua ống, đèn tắt khi nơi máy hút bụi lướt qua đã sạch sẽ, hết bụi bẩn, làm sạch hiệu quả cho ngôi nhà bạn, không bỏ sót lại bất kì hạt bụi nào. Những hạt bụi có kích thước nhỏ 20 μm, mắt thường không thể nhìn thấy, thì giờ không còn là vấn đề nữa.
	</p>
	<h5>Đi kèm đầu hút sàn, đầu hút khe nhỏ, chổi vệ sinh sử dụng tiện lợi cho mọi không gian</h5>
	<p>
	Hỗ trợ giúp tăng thêm không gian hút, giúp bạn làm sạch vết bẩn trên sàn, thảm, gối, nệm, bàn phím máy vi tính,... làm sạch hiệu quả cho căn nhà của bạn.
	<br>
	<br>
	Máy hút bụi không dây Panasonic S48 thiết kế gọn nhẹ có thể cầm nắm bằng 1 tay cùng với cảm biến thông minh rất phù hợp các chị em phụ nữ khi vệ sinh ngôi nhà thân yêu của mình.
	</p>
' where id = 48
go

update products set [description] =N'
	<h5>Máy hút bụi Samsung S49 được thiết kế gọn gàng, đơn giản</h5>
	<h5>Dung tích hộp chứa bụi 2 lít giúp thời gian hút bụi không bị ngắt quãng</h5>
	<p>
	Sản phẩm được thiết kế bình chứa bụi lớn, dễ tháo lắp để vệ sinh. Có thể tái sử dụng mà không cần phải thay thế như túi đựng bụi.
	</p>
	<h5>Công suất hoạt động 2200W và công suất hút 430W tối đa việc dọn dẹp nhà cửa</h5>
	<p>
	Máy hút bụi với công suất hút mạnh mẽ giúp hút sạch bụi bẩn trong nhà ngay cả khi ở những góc hẹp. Máy giúp hút sạch bụi bẩn nhanh chóng không mất nhiều thời gian, công việc dọn nhà trở nên đơn giản, nhẹ nhàng.
	</p>
	<h5>Bộ lọc HEPA H13 cùng với công nghệ Super Twin Chamber hiện đại</h5>
	<p>
	Máy hút bụi dạng hộp trang bị bộ lọc HEPA H13 hiện đại, giúp loại bỏ bụi bẩn lên đến 99.95%, kể cả các hạt bụi nhỏ nhất mang lại không gian sống luôn sạch sẽ.
	</p>
	<h5>Công nghệ hiện đại Super Twin Chamber hay còn gọi là ngăn chứa bụi đôi, cải tiến cho lực hút tối ưu, chống lông tóc rối so với các loại máy thông thường</h5>
	<h5>Dây điện dài 6.9m thuận tiện cho việc di chuyển ở những không gian rộng hơn</h5>
	<h5>Các phụ kiện đi kèm khi mua máy: đầu hút sàn, đầu hút đa năng, ống linh hoạt, ống nối dài</h5>
	<p>
	Sử dụng đầu hút phù hợp với không gian vệ sinh. Ví dụ: ống nối dài hút những chỗ cao như trên tường nhà, đầu hút đa năng hút những vật dụng khó vệ sinh như bàn phím máy tính,...
	</p>
	<p>
	Lưu ý khi dùng máy hút bụi:
	<br>
	- Chọn đầu hút phù hợp với khu vực cần làm sạch để hiệu quả làm sạch cao hơn.
	<br>
	- Di chuyển máy nhẹ nhàng, không quăng, ném để tránh làm hư hỏng các thiết bị bên trong.
	<br>
	- Kiểm tra, vệ sinh, bảo dưỡng máy thường xuyên, định kỳ.
	<br><br>
	Máy hút bụi Samsung S49 thương hiệu Samsung uy tín của Hàn Quốc, được nhiều người tin dùng về độ hút bụi hiệu quả.
' where id = 49
go

update products set [description] =N'
	<h5>Máy lọc nước Kangaroo có thiết kế tủ đứng với màu sắc hiện đại, phù hợp với không gian gia đình, văn phòng làm việc hay cửa hàng ăn uống...</h5>
	<h5>Màng lọc RO Membrane của máy lọc nước uống trực tiếp nhập khẩu Hàn Quốc cho hiệu quả lọc vi khuẩn đến 99.9%, cung cấp nguồn nước tinh khiết</h5>
	<p>
	Máy lọc nước KG99A VTU KG là thế hệ tiếp theo của dòng VTU KG109A tuy nhiên bình áp đã được thay thế chất liệu là vỏ nhựa giúp giá thành sản phẩm rẻ hơn.
	</p>
	<h5>Hệ thống 9 lõi lọc, lọc sạch tuyệt đối, cho nước tinh khiết an toàn, bổ sung khoáng và vi chất có lợi</h5>
	<p>
	- Lõi PP 5 micron: Loại bỏ tạp chất, cặn bẩn kích thước > 5 micron có trong nước, tăng thời gian sử dụng cho các lõi kế tiếp.
	<br>
	- Lõi Than hoạt tính: Loại bỏ Clo, Clorine, hấp thụ chất hữu cơ dư thừa, các chất khí gây mùi trong nước, kim loại nặng, thuốc trừ sâu, chất gây mùi và các chất oxy hóa gây hỏng màng RO.
	<br>
	- Lõi PP 1 micron: Loại bỏ tạp chất, cặn bẩn kích thước > 1 micron có trong nước (bùn đất, sạn cát), rong rêu, bảo vệ màn R.O
	<br>
	- Màng lọc RO 50GDP: Lọc sạch ở cấp độ phân tử các ion kim loại nặng, amoni, asen, các chất hữu cơ, vi khuẩn, virus…
	<br>
	- Lõi Ceramic: Lọc 99% chất rắn hòa tan, các ion kim loại, tạp chất hữu cơ, loại bỏ vi khuẩn gây các bệnh về tiêu hóa (như: E.coli, Coliform, Cryptosporidium, Giardia), trầm tích, clo, mùi hôi.
	<br>
	- Lõi ORP (Hydrogen): Tạo ra nước có Ph và điện giải phù hợp trở thành nước uống lý tưởng cho cơ thể giúp ngăn chặn lão hóa, giải độc cơ thể, tăng cường miễn dịch, ngăn ngừa các bệnh mãn tính và hỗ trợ trong việc giảm mỡ máu.
	<br>
	- Lõi Alkaline: Tăng chỉ số pH, bổ sung các chất dinh dưỡng ngăn lão hóa, giải độc cơ thể, hỗ trợ giảm quá trình oxy hoá, tạo nước kiềm tính trung hòa axit dư thừa có trong nước.
	<br>
	- Lõi Mineral: Bổ sung Canxi, Magie, Natri, Kali và những khoáng chất khác, các chất điện giải có ích cần thiết cho cơ thể con người: Nâng cao pH, giúp trung hòa axit dư làm cơ thể khỏe hơn.
	<br>
	- Lõi Nano Silver (Nano Bạc): Diệt khuẩn, khử mùi, tạo vị ngọt tự nhiên cho nước.
	</p>
	<h5>Công suất lọc 10 - 12 lít/giờ, dung tích bình chứa nước tới 8 lít đáp ứng tốt nhu cầu nước cho gia đình, nhóm người có đông thành viên</h5>
	<h5>Máy có tỷ lệ lọc - thải là 38/62 thu hồi 38% nước tinh khiết</h5>
	<h5>Dễ dàng lấy nước bằng cách dùng cần gạt, chất liệu vòi bằng thép không gỉ an toàn cho sức khoẻ</h5>
	<p>
	Máy lọc nước RO Kangaroo S50 lõi còn gọi là máy lọc tại vòi, mang thương hiệu Kangaroo uy tín, chất lượng mang lại nguồn nước tinh khiết, sạch sẽ và an toàn để chăm sóc sức khoẻ cho cả gia đình bạn.
	</p>
' where id = 50
go

update products set [description] =N'
	<h5>Máy lọc nước Sunhouse với kiểu dáng tủ đứng gọn đẹp, vỏ tủ kính cường lực tràn viền màu đen sang trọng, họa tiết đơn giản mà tinh tế, giữ sản phẩm hài hòa trong không gian sống hiện đại</h5>
	<p>
	Chất liệu vỏ bền đẹp, dễ vệ sinh, giữ diện mạo của máy luôn sáng bóng, mới lâu.
	</p>
	<h5>Lọc sạch, bổ sung khoáng chất cho nước, kháng khuẩn bằng Nano bạc với hệ thống lọc 9 lõi lọc hiện đại</h5>
	<p>
	- Lõi PP 5 micron: Loại bỏ tạp chất, cặn bẩn kích thước > 5 micron, tăng tuổi thọ cho các lõi kế tiếp.
	<br>
	- Lõi Than hoạt tính (dạng hạt): Hấp thụ một phần chất hữu cơ, kim loại nặng, thuốc trừ sâu, chất gây mùi,…
	<br>
	- Lõi PP 1 micron: Loại bỏ các hạt cặn có kích thước > 1 micron, bảo vệ màng RO.
	<br>
	- Màng R.O nhập khẩu Hàn Quốc: Loại bỏ hoàn toàn tạp chất, ion kim loại nặng, vi khuẩn, các chất hữu cơ, amip, asen,…
	<br>
	- Lõi tạo vị: Cân bằng pH, tạo khoáng và vị ngọt tự nhiên cho nước.
	<br>
	- Lõi Maifan: Bổ sung vi lượng khoáng chất từ thiên nhiên cần thiết cho cơ thể như sắt, canxi, magie,…
	<br>
	- Lõi Alkaline (Lõi tạo kiềm tính): Tăng chỉ số pH, tạo nước kiềm tính và trung hòa axit dư trong cơ thể.
	<br>
	- Lõi hồng ngoại xa (Far Infrared): Phân cực phân tử nước, giúp cơ thể hấp thụ nước dễ hơn.
	<br>
	- Lõi Nano Silver (Nano Bạc): Diệt khuẩn, khử mùi, cân bằng pH, tạo khoáng và vị ngọt tự nhiên cho nước.
	<br>
	Chế độ cút nối giúp các lõi lọc dễ dàng tháo lắp thay thế, tiện dụng hơn cho người sử dụng.
	</p>
	<h5>Công suất lọc 10 – 15 lít/giờ, dung tích bình chứa nước 8 lít sử dụng thoải mái cho nhu cầu gia đình hoặc văn phòng nhỏ ít người</h5>
	<h5>Máy có tỷ lệ lọc - thải là 30/70 thu hồi 30% nước tinh khiết</h5>
	<h5>Dễ dàng lấy nước bằng cách dùng cần gạt, chất liệu vòi bằng thép không gỉ an toàn cho sức khoẻ</h5>
	<p>
	Máy lọc nước RO Sunhouse S51 9 lõi công nghệ lọc tân tiến cung cấp nước sạch an toàn, tốt cho sức khỏe. Máy lọc nước uống trực tiếp này đáng trang bị phục vụ nhu cầu sống gia đình.
	</p>
' where id = 51
go

update products set [description] =N'
	<h5>Máy lọc nước RO Kangaroo S52 10 lõi có thiết kế hiện đại, sang trọng, sử dụng được trong gia đình như phòng khách, nhà bếp hoặc dùng trong văn phòng, nhà hàng, khách sạn</h5>
	<h5>Máy lọc nước Kangaroo có khả năng lọc lên đến 10 - 12 lít/giờ, trong đó dung tích bình nước nóng 0.8 lít, nước thường 8 lít, nước lạnh 0.8 lít</h5>
	<p>
	Đảm bảo khả năng lọc nhanh chóng và đáp ứng đầy đủ nhu cầu nước uống liên tục cho nhiều người. Sản phẩm còn có khả năng tự động lọc và ngừng khi đủ nước, thải nước thải và bảo vệ khi quá nhiệt.
	</p>
	<h5>Máy có tỷ lệ lọc - thải là 30/70 thu hồi 30% nước tinh khiết</h5>
	<p>
	Trong điều kiện tiêu chuẩn, với 10 lít nước đưa vào máy sẽ lọc được 3 lít nước tinh khiết để uống và 7 lít được thải ra ngoài.
	<br>
	Lượng nước thải ra, bạn có thể tái sử dụng cho hoạt động sinh hoạt, vệ sinh khác của gia đình như giặt đồ, lau dọn nhà cửa, nhà vệ sinh hay tưới cây,…
	<br>
	Bình chứa được làm bằng thép cao cấp không gỉ, bền bỉ giúp đảm bảo lượng nước sau khi lọc vẫn giữ được độ tinh khiết và ngăn chặn vi khuẩn xâm nhập.
	<br>
	<h5>Máy lọc nước sử dụng công nghệ lọc RO cùng hệ thống 10 cấp lọc nước tạo ra nguồn nước sạch và đầy đủ khoáng chất</h5>
	<p>
	- Lõi sợi PP 5 micron: Loại bỏ tạp chất, cặn bẩn kích thước > 5 micron có trong nước, tăng thời gian sử dụng cho các lõi kết tiếp.
	<br>
	- Lõi than hoạt tính: Loại bỏ Clo, hấp thụ chất hữu cơ dư thừa, các chất khí gây mùi trong nước, kim loại nặng, thuốc trừ sâu, chất gây mùi và các chất oxy hóa gây hỏng màng RO.
	<br>
	- Lõi sợi PP 1 micron: Loại bỏ tạp chất, cặn bẩn kích thước > 1 micron có trong nước (bùn đất, sạn cát), rong rêu, bảo vệ màn R.O.
	<br>
	- Màng lọc RO 50 GPD: Lọc sạch ở cấp độ phân tử các ion kim loại nặng, amoni, asen, các chất hữu cơ, vi khuẩn, virus,…
	<br>
	- Lõi Ceramic: Lọc 99% chất rắn hòa tan, các ion kim loại, tạp chất hữu cơ, loại bỏ vi khuẩn gây các bệnh về tiêu hóa (như: E.coli, Coliform, Cryptosporidium, Giardia), trầm tích, Clo, mùi hôi.
	<br>
	- Lõi Alkaline: Tăng chỉ số pH, bổ sung các chất dinh dưỡng ngăn lão hóa, giải độc cơ thể, hỗ trợ giảm quá trình oxy hóa, tạo nước kiềm tính trung hòa axit dư thừa có trong nước.
	<br>
	- Lõi Maifan: Bổ sung Canxi, Magie, Natri, Kali và những khoáng chất khác, các chất điện giải có ích cần thiết cho cơ thể con người. nâng cao pH, giúp trung hòa axit dư làm cơ thể khỏe hơn.
	<br>
	- Lõi ORP (Hydrogen): Tạo ra nước có pH và điện giải phù hợp trở thành nước uống lý tưởng cho cơ thể giúp ngăn chặn lão hóa, giải độc cơ thể, tăng cường miễn dịch, ngăn ngừa các bệnh mãn tính và hỗ trợ trong việc giảm mỡ máu.
	<br>
	- Lõi 5 in 1: Tái tạo khoáng tự nhiên, kết hợp tối ưu các thành phần khoáng.
	<br>
	- Lõi Nano Silver (Nano Bạc): Diệt khuẩn, khử mùi, tạo vị ngọt tự nhiên cho nước.
	</p>
	<h5>Thiết kế với 2 vòi nước cùng 3 cần gạt lấy nước riêng biệt, dễ nhận biết, giúp bạn có thể lấy được nước nóng/lạnh và nước RO tiện lợi, dễ dàng</h5>
	<p>
	Máy lọc nước RO Kangaroo S52 10 lõi có thiết kế hiện đại, sang trọng, sử dụng được trong gia đình như phòng khách, nhà bếp hoặc dùng trong văn phòng, nhà hàng, khách sạn.
	</p>
' where id = 52
go

update products set [description] =N'
	<h5>Máy lọc nước Kangaroo thiết kế không vỏ có thể lắp âm gọn gàng trong tủ bếp, tiết kiệm không gian sử dụng</h5>
	<h5>Máy lọc nước công nghệ RO với hệ 9 lõi lọc cho nước sử dụng sạch an toàn, có lợi hơn cho sức khỏe</h5>
	<p>
	- Lõi số 1 – Lõi PP 5 micron loại bỏ cặn bẩn, rỉ sét kích thước > 5 micron.
	<br>
	- Lõi số 2 – Lõi than hoạt tính hấp thụ mùi, chất hữu cơ, thuốc trừ sâu, Clo có trong nước.
	<br>
	- Lõi số 3 – Lõi PP 1 micron loại bỏ tạp chất, vi khuẩn còn sót lại kích thước > 1 micron.
	<br>
	- Lõi số 4 – Màng RO GPD Hàn Quốc loại bỏ hoàn toàn chất rắn, khí trong nước, ion kim loại nặng, vi khuẩn, vi sinh vật, các chất hữu cơ, cho nước đầu ra tinh khiết mà không thay đổi tính lý – hóa của nước, giảm đến 30% lượng nước thải so với màng RO thông thường.
	<br>
	- Lõi số 5 – Lõi ORP (Hydrogen) tạo điện giải cho nước giúp cơ thể thải độc.
	<br>
	- Lõi số 6 – Lõi Alkaline trung hòa axit dư thừa, tạo nước kiềm tính và bổ sung ion canxi tăng cường sức khỏe.
	<br>
	- Lõi số 7 – Lõi Maifan bổ sung khoáng chất từ thiên nhiên cho nước, tăng cường sức đề kháng cho cơ thể.
	<br>
	- Lõi số 8 – Lõi 5 in 1 lõi khoáng đặc biệt tạo ion âm bổ sung cho nước, giúp nước dễ hấp thụ hơn trong cơ thể.
	<br>
	- Lõi số 9 – Lõi Nano Silver (Nano Bạc) sử dụng ion Ag+ để thâm nhập vào các tế bào vi sinh vật, có thể diệt tới 99.99% vi khuẩn trong nước và khử mùi cho nước.
	</p>
	<h5>Với công suất lọc 10 – 15 lít giờ, dung tích bình chứa 8 lít sử dụng thoải mái cho nhu cầu gia đình, các khu công cộng</h5>
	<h5>Máy có tỷ lệ lọc - thải là 3/7 thu hồi 30% nước tinh khiết</h5>
	<h5>Sản phẩm đi kèm vòi nước inox chất lượng cao, bền tốt, đảm bảo vệ sinh cho nguồn nước lấy ra sử dụng</h5>
	Máy lọc nước RO không vỏ Kangaroo S53 9 lõi cho gia đình nguồn nước sạch an toàn, tốt cho sức khỏe, đơn giản sử dụng, độ bền cao, đáng đầu tư chọn dùng.
	</p>
' where id = 53
go

update products set [description] =N'
	<h5>Vẻ đẹp tinh tế của máy lọc nước tại vòi thiết kế kiểu dáng phong cách hàn Quốc</h5>
	<p>
	Máy lọc nước Korihome S54 được thừa hưởng phong cách thiết kế tinh tế và sang trọng từ Hàn Quốc giúp cho không gian sống của gia đình bạn trở nên hiện đại và đẳng cấp hơn. Bạn sẽ dễ dàng đặt máy ở bất kỳ vị trí nào.
	</p>
	<h5>Máy lọc nước nóng lạnh với công suất lọc 15 lít/giờ, cung cấp 2 lít nước nóng và 3.8 lít nước lạnh phục vụ thoải mái cho nhu cầu sử dụng tại gia đình, văn phòng, ...</h5>
	<p>
	Bình chứa máy lọc nước được làm từ Inox 304 an toàn cho người sử dụng, không gây ảnh hưởng đến nguồn nước tinh khiết.
	</p>
	<h5>2 vòi nóng lạnh riêng biệt, thiết kế dễ dàng rót nước, tích hợp tính năng khoá vòi nước nóng an toàn cho gia đình có trẻ nhỏ</h5>
	<h5>Có van chỉnh nhiệt độ lạnh, công tắc nước nóng và nước lạnh độc lập cho người dùng chủ động chế độ sử dụng máy lọc nước</h5>
	<p>
	Có van chỉnh chủ động điều chỉnh được nhiệt độ lạnh (8~15°C) phù hợp với nhu cầu sử dụng. Đặc biệt đối với các gia đình có trẻ nhỏ.
	</p>
	<h5>Máy lọc nước RO với hệ thống 7 lõi lọc nguyên khối, thay nhanh cao cấp của Hàn Quốc. Sức mạnh vượt trội, có lợi cho sức khỏe người dùng</h5>
	<p>
	- 2 lõi Sediment : Loại bỏ tạp chất, cặn bẩn kích thước > 5 micron có trong nước, tăng thời gian sử dụng cho các lõi kế tiếp.
	<br>
	- Lõi Pre Carbon: Loại bỏ Clo, Clorine, hấp thụ chất hữu cơ dư thừa, các chất khí gây mùi trong nước, kim loại nặng, thuốc trừ sâu, chất gây mùi và các chất oxy hóa gây hỏng màng RO
	<br>
	- Màng lọc RO 80GPD: Lọc sạch ở cấp độ phân tử các ion kim loại nặng, amoni, asen, các chất hữu cơ, vi khuẩn, virus…
	<br>
	- Lõi Post Carbon: Hấp thụ màu, mùi, cân bằng độ pH, tăng vị tươi mát cho nước.
	<br>
	- Lõi ORP Alkaline (Hydrogen Alkaline): Tạo nguồn nước kiềm Hydrogen ở dạng hoạt hóa có công dụng trung hòa và hấp thu các gốc tự do (nguyên nhân gây sự hóa già, lão suy, Alzheimer, tăng huyết áp vô căn, đái tháo đường, bệnh xơ vữa động mạch, ung thư) vì vậy hỗ trợ giữ gìn sức khỏe, đồng thời tăng cường thể lực, tốt cho hệ tiêu hóa.
	<br>
	- Lõi hồng ngoại xa (Far Infrared): Giúp nước đi qua lõi lọc được hoạt hóa, chia nhỏ các nhóm phân tử nước giúp cơ thể dễ dàng hấp thu hơn.
	</p>
	<h5>Bơm - hút 2 chiều, van điện từ, cho khả năng hút sâu tới 2 mét cung cấp nguồn nước ổn định cho màng lọc RO</h5>
	<p>
	Máy lọc nước RO nóng lạnh Korihome S54 7 lõi cung cấp nước sạch phục vụ tốt cho cả nhu cầu dùng nóng và dùng lạnh thật tiện ích, an toàn, có lợi hơn cho sức khỏe người dùng.
	</p>
' where id = 54
go

update products set [description] =N'
	<h5>Máy lọc nước ion kiềm thương hiệu Panasonic toàn cầu, thành lập hơn 100 năm, đảm bảo chất lượng với sản phẩm nhập khẩu nguyên kiện từ Nhật Bản</h5>
	<p>
	Máy lọc nước đảm bảo chất lượng với 5 chứng nhận tiêu chuẩn quốc tế uy tín bao gồm chứng nhận ISO 9001, JWPA, NSF, JIS, Cục An toàn thực phẩm - Bộ Y tế Việt Nam.
	<br>
	- ISO 9001: Chuẩn quốc tế về hệ thống quản lý chất lượng.
	<br>
	- JWPA: Loại bỏ 4 chất độc hại theo quy định của Hiệp hội máy lọc nước Nhật Bản.
	<br>
	- NSF: Chứng nhận an toàn vệ sinh thực phẩm đối với than hoạt tính trong lõi lọc tinh.
	<br>
	- JIS: Chứng nhận loại bỏ 13 chất độc hại theo quy định Tiêu chuẩn công nghiệp Nhật. 
	<br>
	- Cục An toàn thực phẩm - Bộ Y tế Việt Nam: Chứng nhận nước an toàn cho sức khỏe. Chất lượng nước đạt chuẩn QCVN 6-1:2010/BYT.
	<h5>Phục vụ tốt cho mọi nhu cầu cuộc sống với 5 loại nước gồm 3 nước ion kiềm, nước tinh khiết và nước axit nhẹ</h5>
	<p>
	- Nước ion kiềm cấp độ 1 - Alkaline 1 (độ pH 8.5): Phù hợp cho người mới dùng nước ion kiềm, sử dụng uống hằng ngày, tốt cho sức khỏe, cải thiện đường tiêu hóa hiệu quả.  
	<br>
	- Nước ion kiềm cấp độ 2 - Alkaline 2 (độ pH 9.0): Sử dụng uống trực tiếp và nấu cơm, nước ion kiềm có tác dụng thẩm thấu nhanh cho hương vị thực phẩm nổi bật hơn. 
	<br>
	- Nước ion kiềm cấp độ 3 - Alkaline 3 (độ pH 9.5): Sử dụng để uống, nấu ăn (súp, hầm), pha trà, cà phê. Khả năng thẩm thấu sâu, mạnh mẽ, chiết xuất dưỡng chất, đẩy nhanh quá trình nấu chín mà vẫn giữ trọn hương vị của món ăn. 
	<br>
	- Nước lọc – Nước tinh khiết - Purified (độ pH 7.0): Sử dụng uống thuốc tây, phù hợp làm nước uống hằng ngày cho bé từ 6 tháng - 5 tuổi, pha sữa, nấu ăn cho trẻ nhỏ.
	<br>
	- Nước axit yếu - Weak Acidic (độ pH 5.5): Sử dụng rửa mặt, làm đẹp da nhờ tính axit nhẹ gần độ pH của da giúp cân bằng pH, se khít lỗ chân lông, cho da mặt bạn đẹp hơn mỗi ngày.
	</p>
	<h5>Nước ion kiềm mang lại nhiều lợi ích sức khỏe</h5>
	<p>
	Nước ion kiềm là nước có độ pH cao, tương tự như rau xanh, có khả năng trung hòa axit trong dạ dày, là lựa chọn tốt để điều trị rối loạn đường tiêu hóa, như tăng tiết dạ dày, tiêu chảy, làm sạch ruột và giải độc, tăng cường sự phát triển của men vi sinh tốt hỗ trợ cơ thể hấp thụ chất dinh dưỡng.
	<br>
	Nước sinh hoạt chúng ta thường dùng, kể cả nước uống thông thường thường có tính axit nhẹ. Máy lọc nước ion kiềm cung cấp nguồn nước uống có lợi nhất cho sức khỏe, là lựa chọn đáng ưu tiên cho cơ thể.
	</p>
	<h5>Panasonic S55 3 tấm điện cực cung cấp nước tốt cho hệ tiêu hóa khỏe mạnh, đã được phê duyệt theo quy định Đạo luật về thiết bị y dược Nhật Bản (Đạo luật PMD)</h5>
	<h5>Hệ thống 1 lõi lọc 4 cấp tiên tiến gồm vải không dệt, gốm, than hoạt tính và màng sợi rỗng loại bỏ các chất bẩn cho nguồn nước đầu ra sạch sẽ, tinh khiết, an toàn cho sức khỏe</h5>
	<h5>Kiểu dáng để bàn khá gọn nhẹ với khối lượng 3 kg, vỏ nhựa kháng vỡ, thiết kế kết cấu đơn giản, dễ dàng bố trí trong nhiều không gian như phòng bếp, phòng khách, phòng ngủ, ...</h5>
	<h5>Công suất lọc 2.0 lít/phút hay 108 – 168 lít/giờ, đảm bảo nguồn nước sạch luôn sẵn sàng cho bạn sử dụng mọi lúc</h5>
	<h5>Bảng điều khiển bấm cơ học chỉ dẫn ngôn ngữ tiếng Anh - Trung đi kèm đèn báo cho từng chế độ nước giúp người dùng dễ theo dõi và tùy chỉnh chế độ chính xác</h5>
	<p>
	Máy lọc nước Ion kiềm Panasonic S55 3 tấm điện cực, sản phẩm lọc nước cao cấp của thương hiệu Panasonic mang đến 5 nguồn nước sạch, công suất lọc đến 108 – 168 lít/giờ, vòi xoay linh hoạt, kiểu dáng dễ lắp đặt ở nhiều nơi, hỗ trợ hệ thống lọc 4 cấp và công nghệ điện phân tiên tiến, tin tưởng sẽ giúp bạn nâng cao chất lượng cuộc sống gia đình. 
	</p>
' where id = 55
go

update products set [description] =N'
<h5>Kiểu dáng đơn giản, trang nhã cùng dung tích lò 25 lít thích hợp cho sử dụng gia đình</h5>
<h5>Khoang lò bằng thép tráng men bền đẹp, dễ chùi rửa, bên trong có đèn tiện quan sát trong quá trình nấu nướng</h5>
<h5>Công suất 800 W cùng các chức năng như nấu, hâm nóng, rã đông giúp người nội trợ nhẹ nhàng hơn khi vào bếp</h5>
<h5>Bảng điều khiển bằng núm vặn đơn giản, dễ dùng</h5>
<p>
Chế độ hẹn giờ nấu (đến 35 phút) an toàn và tiện lợi hơn ngay cả khi người dùng nấu ăn lúc bận rộn.
</p>
<h5>Chức năng rã đông nhanh hỗ trợ người dùng nấu nướng nhanh gọn hơn</h5>
<p>
Lò vi sóng Panasonic 25 lít S56 thiết kế đẹp, tiện dụng, giá tốt, thương hiệu uy tín đáng tin dùng.
</p>
<p>
<b>Lưu ý khi sử dụng lò vi sóng:</b>
<br>
- Không dùng chung ổ điện với các thiết bị điện khác.
<br>
- Để thêm một cốc nước khi hâm nóng thức ăn khô.
<br>
- Không sử dụng đồ đựng thức ăn bằng kim loại trong lò vi sóng.
<br>
- Đặt lò vi sóng ở nơi thoáng mát, không gần các thiết bị điện khác như: tủ lạnh, bếp gas,...
<br>
- Trước khi vệ sinh khoang lò, phải rút điện ra trước, không dùng các chất tẩy rửa mạnh để lau chùi. 
</p>
' where id = 56
go

update products set [description] =N'
<h5>Lò vi sóng Panasonic NN-ST25JWYUE 20 lít kích thước nhỏ gọn, màu sắc trang nhã phù hợp với mọi không gian bếp</h5>
<h5>Dung tích 20 lít có thể bỏ vừa gà nguyên con khoảng 1 kg</h5>
<h5>Lò vi sóng đa dạng các chức năng: hâm, nấu, rã đông theo thời gian hay theo trọng lượng, nấu tự động với các món như cá, rau, khoai tây,... </h5>
<p>
Bảng điều khiển điện tử bằng nút nhấn, có hỗ trợ tiếng Việt dễ dùng ngay cả với người lớn tuổi. Công suất lò 800W giúp nấu ăn nhanh, tiết kiệm thời gian.
</p> 
<h5>Lò vi sóng Panasonic còn có tính năng hẹn giờ tiện lợi, giúp bạn nấu ăn dễ dàng mà không cần phải trông chừng
<h5>Khoang lò được tráng men bền bỉ, hạn chế bám bẩn, dễ dàng vệ sinh sau khi dùng
<h5>Khoang lò có đèn bên trong tiện lợi
<p>
Lò vi sóng Panasonic S57 20 lít thương hiệu Panasonic uy tín của Nhật Bản, đa dạng chức năng nấu là công cụ không thể thiếu trong gian bếp của gia đình bạn. 
</p>
<p>
<b>Lưu ý khi sử dụng lò vi sóng:</b>
<br>
- Không dùng chung ổ điện với các thiết bị điện khác.
<br>
- Để thêm một cốc nước khi hâm nóng thức ăn khô.
<br>
- Không sử dụng đồ đựng thức ăn bằng kim loại trong lò vi sóng.
<br>
- Đặt lò vi sóng ở nơi thoáng mát, không gần các thiết bị điện khác như: tủ lạnh, bếp gas,...
<br>
- Trước khi vệ sinh khoang lò, phải rút điện ra trước, không dùng các chất tẩy rửa mạnh để lau chùi. 
</p>
' where id = 57
go

update products set [description] =N'
<h5>Thiết kế sang trọng, gọn nhẹ, dễ lắp đặt, có khóa bảng điều khiển</h5>
<p>
Lò vi sóng Sharp S58 không chiếm nhiều diện tích trong căn bếp của bạn.
<br>
Khóa bảng điều khiển khi kích hoạt sẽ vô hiệu hóa toàn bộ bàn phím bảng điều khiển, trẻ nhỏ có vô tình bấm vào các phím cũng không ảnh hưởng đến hoạt động của lò.
</p>
<h5>Đèn bên trong lò giúp bạn dễ dàng theo dõi quá trình chế biến, nấu ăn dễ dàng</h5>
<h5>Khoang lò thiết kế rộng, đĩa xoay lớn, dung tích 23 lít</h5>
<p>
Giúp bạn đựng được nhiều thực phẩm, nấu ăn tiết kiệm thời gian, công sức, dễ làm sạch khi bị bẩn.
</p>
<h5>Chức năng đa dạng</h5>
<p>
Lò vi sóng Sharp S58 tích hợp 4 chức năng chính là hâm nóng, nấu, rã đông, nướng kết hợp với công suất vi sóng tối đa lên đến 800W, công suất nướng lớn 1000W, 5 mức công suất khác nhau giúp bạn chế biến các món ngon đa dạng, thuận tiện.
<br>
Đặc biệt, chức năng rã đông có rã đông theo trọng lượng và theo thời gian giúp bạn rã đông thực phẩm linh hoạt, nhanh chóng hơn.
<br>
Lò vi sóng còn được thiết lập nhiều thực đơn tự động như nấu cơm, mì ống, rau củ quả, pizza, thịt nướng,… cho phép chị em thay đổi thực đơn gia đình mỗi ngày mà không sợ trùng lặp, nhàm chán.
<br>
Chức năng hẹn giờ giúp bạn tùy chỉnh thời gian hẹn cho từng món ăn khác nhau. Nhờ đó, món ăn được nấu ngon, đúng cách, bổ dưỡng và hấp dẫn hơn.
<br>
<h5>Bảng điều khiển điện tử có ghi chú tiếng Việt dễ hiểu</h5>
<p>
Thiết kế 1 nút xoay tiện dụng, thân thiện người dùng, màn hình LED hiển thị rõ ràng giúp bạn chỉnh các mức công suất, chế độ, chức năng đơn giản, chính xác.
</p>
<p>
Lò vi sóng Sharp S58 mẫu mã đẹp mắt, sang trọng, nhiều chức năng tiện dụng, nấu nướng nhanh chóng, tiện lợi.
</p>
<p>
<b>Lưu ý khi sử dụng lò vi sóng:</b>
<br>
- Không dùng chung ổ điện với các thiết bị điện khác.
<br>
- Để thêm một cốc nước khi hâm nóng thức ăn khô.
<br>
- Không sử dụng đồ đựng thức ăn bằng kim loại trong lò vi sóng.
<br>
- Đặt lò vi sóng ở nơi thoáng mát, không gần các thiết bị điện khác như: tủ lạnh, bếp gas,...
<br>
- Trước khi vệ sinh khoang lò, phải rút điện ra trước, không dùng các chất tẩy rửa mạnh để lau chùi. 
</p>
' where id = 58
go

update products set [description] =N'
<h5>Lò vi sóng Toshiba thiết kế để bàn với mẫu mã đơn giản, truyền thống, dùng hài hòa trong mọi không gian</h5>
<p>
Sản phẩm đa chức năng: nấu, hâm nóng, rã đông, nướng, với công suất 800W nấu nhanh, tiện dụng. Dung tích 20 lít nhỏ gọn dễ dùng tại gia đình.
</p>
<h5>Lò vi sóng có nướng với khoang lò bằng thép không gỉ, dễ lau chùi, nấu nướng thực phẩm an toàn, đảm bảo sức khỏe</h5>
<h5>Bảng điều khiển điện tử hiện đại, hướng dẫn có chú thích Tiếng Việt, dễ dàng sử dụng ngay từ lần thử dùng đầu tiên</h5>
<p>
5 mức công suất tùy chỉnh theo món nấu, 3 chương trình nướng kết hợp hỗ trợ người dùng chuẩn bị những bữa ăn đa dạng, hấp dẫn tại gia đình cách nhanh chóng hơn và đơn giản hơn.
<br>
Hẹn giờ nấu lên đến 35 phút cho người dùng rảnh tay với công việc bếp núc khác trong khi nấu ăn với lò vi sóng.
</p>
<h5>Chế độ rã đông theo trọng lượng tiện lợi, giúp thực phẩm được rã đông ngon hơn, bảo toàn tốt dưỡng chất</h5>
<h5>Khoang lò có đèn tiện lợi</h5>
<h5>Kèm theo lò vi sóng có vỉ nướng cho các món nướng thêm tiện lợi, đơn giản, ngon hơn và đẹp mắt hơn</h5>
Lò vi sóng Toshiba S59 20 lít gia dụng chất lượng tốt, tiện ích cao, dùng bền, đơn giản hóa việc nấu ăn gia đình, giá tốt cho tiêu dùng.
<p>
<b>Lưu ý khi sử dụng lò vi sóng:</b>
<br>
- Không dùng chung ổ điện với các thiết bị điện khác.
<br>
- Để thêm một cốc nước khi hâm nóng thức ăn khô.
<br>
- Không sử dụng đồ đựng thức ăn bằng kim loại trong lò vi sóng.
<br>
- Đặt lò vi sóng ở nơi thoáng mát, không gần các thiết bị điện khác như: tủ lạnh, bếp gas,...
<br>
- Trước khi vệ sinh khoang lò, phải rút điện ra trước, không dùng các chất tẩy rửa mạnh để lau chùi. 
</p>
' where id = 59
go

update products set [description] =N'
<h5>Máy xay sinh tố Sunhouse thiết kế đơn giản, màu trắng tươi sáng, kiểu để bàn gọn đẹp, hiện đại phù hợp nhiều không gian bếp</h5>
<p>
Máy xay sinh tố đa năng với chức năng xay sinh tố, xay hạt, xay thịt, có thể xay đá, xay đậu nành tiện lợi, cho bạn làm đồ uống, sơ chế thức ăn thuận lợi, tiết kiệm công sức.
</p>
<h5>Lưỡi dao 6 cánh bằng inox bền chắc, sắc bén kết hợp với công suất mạnh mẽ 700W xay nhuyễn nhanh mọi nguyên liệu</h5>
<h5>Cối xay sinh tố làm bằng chất liệu thủy tinh và nhựa cao cấp, chịu nhiệt tốt, an toàn cho sức khỏe, cối lớn dung tích sử dụng đến 1.5 lít</h5>
<p>
Cối lớn và cốc đựng bằng thủy tinh chịu nhiệt, cối xay hạt và cối xay thịt bằng nhựa, dễ vệ sinh.
</p>
<h5>Máy xay sinh tố có cối xay thịt 1.2 lít đi kèm lưỡi dao, nắp đậy riêng đảm bảo thịt, cá, hải sản được xay nhuyễn nhanh, không rơi vãi ra ngoài</h5>
<h5>Cối xay hạt nhỏ gọn 250 ml đáp ứng nhu cầu xay tiêu, ớt, hành, tỏi, các loại đậu, hạt...</h5>
<h5>Cốc đựng 500 ml đi kèm nắp đậy kín, tiện cho bạn bảo quản đồ uống vào tủ lạnh luôn mà không cần rót ra ly</h5>
<h5>Điều khiển núm vặn có chỉ dẫn tùy chỉnh 2 tốc độ xay và 1 số nhồi dễ dàng
<p>Máy xay sinh tố Sunhouse Mama S60 giúp mọi người chuẩn bị các món đồ uống bổ dưỡng, thức ăn ngon dễ dàng, tiện lợi nhất.</p>
' where id = 60
go

update products set [description] =N'
<p>
<b>Máy xay sinh tố Kangaroo KGBL600X với 5 tốc độ xay, 1 chế độ nhồi cùng công suất 600W mạnh mẽ và lưỡi dao 6 cánh có răng cưa giúp xay nhanh nhuyễn mịn. Sản phẩm đáp ứng tốt nhu cầu xay sinh tố, rau củ, đá nhỏ sử dụng trong gia đình.</b>
</p>
<h5>Cối xay máy xay sinh tố Kangaroo KGBL600X</h5>
<p>
Sản phẩm có 1 cối dung tích 1.5 lít xay sinh tố, rau củ, đá nhỏ,... bằng thủy tinh an toàn, dễ vệ sinh, hạn chế ám màu và mùi.
</p>
<h5>Công suất - Lưỡi dao</h5>
<p>
Vận hành với mức công suất tối đa 600W cùng lưỡi dao răng cưa 6 cánh bằng inox 304 an toàn, xay đá nhỏ nhuyễn mịn nhanh chóng.
</p>
<h5>Tốc độ - Bảng điều khiển</h5>
<p>
- Máy xay sinh tố Kangaroo 5 tốc độ và 1 nút nhồi tiện trộn nguyên liệu, chống tắc nghẽn, xay nhuyễn đều.
<br>
- Điều khiển nút xoay dễ dàng tùy chỉnh.
</p>
<h5>Các tiện ích và chức năng an toàn</h5>
<p>
- Tự ngắt khi quá tải đảm bảo an toàn nguồn điện và thiết bị.
<br>
- Chân đế chống trượt hạn chế rung lắc khi đang sử dụng.
<br>
- Chỉ hoạt động khi lắp đúng khớp.
<br>
- Nắp nhỏ tiếp nguyên liệu khi xay có thể dùng như cốc đong dung tích 40 ml.
</p>
<p>
Máy xay sinh tố Kangaroo S61 vận hành với công suất 600W, lưỡi dao răng cưa 6 cánh có khả năng xay đá nhỏ nhanh chóng, cối thủy tinh an toàn, dễ vệ sinh, hạn chế ám mùi đáp ứng tốt nhu cầu sử dụng trong gia đình.
</p>
' where id = 61
go

update products set [description] =N'
<h5>Máy lọc không khí Sharp màu đen sang trọng, kiểu dáng nhỏ gọn, dễ kết hợp trong nhiều không gian</h5>
<p>
Máy có công suất 23W, phù hợp cho các phòng diện tích từ 20 - 30m2.
</p>
<h5>Vận hành êm ái với độ ồn từ 15 - 45 dB tương đương tiếng lá xào xạc, tiếng thì thầm</h5>
<h5>Bảng điều khiển điện tử hiện đại, 3 cấp độ gió tùy chỉnh theo nhu cầu sử dụng</h5>
<p>
Lượng gió thổi ra theo 4 mức độ: Tự động - Ngủ - Trung bình - Cao, thích hợp cho từng không gian hoạt động.
<br>
Máy lọc không khí có cảm biến chất lượng không khí hỗ trợ người dùng nhận biết và điều chỉnh chế độ dùng, có đèn báo màng lọc gia tăng hiệu quả dùng thiết bị.
<br>
Chế độ hẹn giờ tắt tối đa 8 tiếng, thuận tiện giấc ngủ về đêm.
<br>
Lọc vượt trội với 3 lớp lọc bụi trả lại môi trường không khí sạch trong, an toàn, không mùi hôi, không vi khuẩn độc hại
<br>
- Màng lọc bụi thô: giữ các bụi nhỏ kích thước từ 500 micro trở lên, côn trùng, lông vật nuôi,…
<br>
- Màng lọc than hoạt tính: giúp khử mùi hôi, mùi thuốc lá, vật nuôi, mùi amoniac,…
<br>
- Màng lọc HEPA: loại bỏ các chất gây dị ứng, vi rút, vi khuẩn kích thước 0.3 micro, các chất gây dị ứng và hạt bụi mịn PM2.5,…
</p>
<h5>Máy lọc không khí có chế độ Haze tự điều chỉnh tốc độ quạt</h5>
<p>
Với chế độ này, thiết bị tự động vận hành quạt với tốc độ cao trong 60 phút đầu tiên, sau đó hoạt động luân phiên giữa 2 cấp độ thấp và cao trong 20 phút, để tăng khả năng lọc khí và giải phóng Plasmacluster ion ra ngoài không khí nhằm lọc bụi bẩn và khử mùi hôi một cách hiệu quả nhất.
<br>
<b>Cùng với Plasmacluster ion phát ra 7000 hạt ion/cm3, không khí trong phòng được khử sạch vi khuẩn, nấm mốc, các tác nhân gây dị ứng và mùi khó chịu, bảo vệ sức khỏe gia đình cách an toàn nhất.</b>
</p>
<h5>Chế độ bắt muỗi không độc hại bảo vệ gia đình, với đèn UV dẫn dụ muỗi vào các khe hẹp màu đen trên máy, diệt muỗi bằng keo dính hiệu quả cao</h5>
<h5>Công nghệ Inverter cùng chế độ hẹn giờ tắt, giúp tiết kiệm điện năng tối ưu</h5>
<p>
Máy lọc không khí Sharp S62 thương hiệu Sharp – Nhật Bản, sản xuất tại Thái Lan có tính năng bắt muỗi mà không sử dụng hoá chất, cùng khả năng phát ion diệt virus, nấm mốc sẽ mang đến cho gia đình bạn 1 không gian sống trong lành, an toàn.
</p>
' where id = 62
go

update products set [description] =N'
<p>
<b>Máy lọc không khí LG Puricare Pro S63 thiết kế hiện đại, màu sắc trang nhã, phù hợp với nhiều không gian, lọc được nhiều loại bụi mịn với bộ lọc 3 lớp giúp không khí được lọc sạch hơn trong phạm vi dưới 32.8m2.</b>
</p>
<h5>Thiết kế</h5>
<p>
- Máy lọc không khí LG Puricare Pro S63 thiết kế tinh tế, tối ưu và hướng đến người dùng. Chiều cao của máy cho phép người lớn hoặc trẻ em vận hành dễ dàng, dạng tròn thanh lịch giúp tiết kiệm không gian tạo cho ngôi nhà một nét riêng hiện đại, màu sắc trang nhã thích hợp với nhiều không gian: phòng khách, phòng ngủ,... 
<br>
- Phạm vi lọc dưới 32.8m² cho lưu lượng gió ở mức độ turbo là 6.5 m3/h, ở mức độ cao là 4.5 m3/h.
</p>
<h5>Thông tin bộ lọc - Loại bụi lọc được</h5>
<p>
- Bộ lọc 3 lớp bao gồm: màng lọc thô, màng lọc HEPA E11 và màng lọc khử mùi. Hệ thống lọc 3 bước giúp loại bỏ các chất có hại như các hạt lớn, bụi mịn PM0.02, formaldehyde, SO2 & NO2, virus và vi khuẩn, lọc sạch đến 99.9% bụi mịn PM0.02.
<br>
+ Màng lọc thô: lọc được các hạt có kích thước lớn trong không khí như bụi bẩn, lông thú cưng,...
<br>
+ Màng lọc HEPA E11: loại bỏ bụi mịn có kích thước nhỏ trong không khí như khói, phấn hoa, vi trùng,...
<br>
+ Màng lọc khử mùi: là một bộ lọc khử mùi giúp loại bỏ các mùi: khói thuốc lá, chất thải thực phẩm, lông động vật, NO2, kiềm và axit, hợp chất dầu dễ bay hơi.
<br>
- Lọc được bụi mịn PM10, PM2.5, PM1.0, PM0.02 giúp bạn có một bầu không khí trong lành hơn.
</p>
<h5>Công nghệ và khả năng cảm biến thông minh</h5>
<p>- Với động cơ Inverter bạn có thể tận hưởng không khí đã được lọc sạch trong không gian yên tĩnh, độ ồn thấp chỉ khoảng 20 dB mà vẫn lọc sạch được không khí.
<br>
- Bộ phát ion bắt giữ vi khuẩn và virus, mang lại bầu không khí trong lành cho nhà bạn.
<br>
- Màn hình thông minh hiển thị mức độ hạt bụi trong nhà theo thời gian thực với cảm biến PM1.0 và cảm biến mùi. Cảm biến PM1.0 có thể cảm nhận được các hạt bụi mịn lên đến 1.0 micromet. Cảm biến mùi phát hiện một số hợp chất gây mùi trong không khí.
<br>
- Cảm biến bụi và khí gas nhạy giúp nhanh chóng phát hiện bụi và khí gas để lọc sạch hiệu quả hơn.
<br>
- Dễ dàng kiểm tra chất lượng không khí từ xa hoặc vào ban đêm với đèn hiển thị chất lượng không khí bằng 4 màu khác nhau:
<br>
+ Xanh lá: không khí tươi mới, sạch sẽ.
<br>
+ Vàng: không khí bị ô nhiễm ở mức thấp.
<br>
+ Cam: không khí bị ô nhiễm ở mức trung bình.
<br>
+ Đỏ: không khí đang bị ô nhiễm nghiêm trọng. 
</p>
<p>
Máy lọc không khí LG Puricare Pro S63 sở hữu nhiều tính năng hiện đại: cảm biến chất lượng không khí, công suất 32W lọc sạch hiệu quả trong phạm vi dưới 32.8m2 chắc hẳn sẽ là 1 lựa chọn đáng cân nhắc cho bạn và gia đình để mang lại bầu không khí trong lành cho căn nhà của bạn.
</p>
' where id = 63
go

update products set [description] =N'
<h5>Máy hút bụi Panasonic S64 màu sắc tươi sáng, thiết kế bắt mắt, nhỏ gọn với khối lượng chỉ 3.6 kg</h5>
<h5>Máy hút bụi sử dụng bộ lọc thường, tạo lực hút mạnh mẽ với công suất 1600W giúp làm sạch dễ dàng và nhanh chóng mọi bụi bẩn</h5>
<h5>Túi chứa bụi lớn với dung tích 1.4 lít cho thời gian hút kéo dài, không bị gián đoạn để thay và vệ sinh túi chứa bụi</h5>
<h5>Máy hút bụi có đầu hút sàn, đầu hút khe kèm thêm ống hút nối dài bằng nhựa giúp người dùng dễ dàng vệ sinh mọi ngóc ngách</h5>
<p>
Từ những vị trí cao hay các góc sâu khuất, kệ tủ, màn treo, hay cả bàn phím máy tính,... Máy hút bụi giúp làm sạch toàn diện ngôi nhà bạn.
</p>
<h5>Điều khiển nút nhấn sử dụng đơn giản</h5>
<h5>Tay cầm lớn phía trước giúp người dùng dễ sử dụng và di chuyển quanh nhà</h5>
<h5>Dây điện dài tới 5m cho việc di chuyển thêm linh động, có thể rút gọn cất giữ tiện lợi</h5>
<h5>Máy hút bụi dạng hộp kèm bánh xe cho việc di chuyển thêm nhẹ nhàng</h5>
<p>
Máy hút bụi dạng hộp Panasonic S64, thương hiệu Nhật Bản, sản xuất tại Malaysia là sản phẩm gọn gàng, đẹp mắt, giúp vệ sinh hiệu quả và nhanh gọn. Gia dụng hữu ích, thương hiệu uy tín nên tìm hiểu chọn dùng.
</p>
' where id = 64
go

update products set [description] =N'
<h5>Thiết bị hút bụi và lau sàn 2 trong 1, làm sạch nhà cửa tiện lợi, tiết kiệm công sức</h5>
<p>
Robot hút bụi loại bỏ bụi bẩn dễ dàng còn có thể tự động bật chổi lau, điều chỉnh lượng nước với hộp chứa nước thông minh, lau sàn thuận tiện. 
</p>
<h5>Công suất hút 4200 Pa cho lực hút mạnh, vệ sinh nhà cửa nhanh chóng</h5>
<h5>Làm sạch liên tục đến 150 phút (tùy theo chế độ hoạt động) chỉ trong 1 lần sạc</h5>
<p>
Pin có dung lượng cao cho thời gian làm sạch liền mạch, không gián đoạn, rất tiện dụng trong ngôi nhà có diện tích lớn. Khi pin yếu, robot dễ dàng sạc lại tại trạm sạc trong tầm 4 giờ.
</p>
<h5>Quản lý robot dễ dàng bằng điện thoại với ứng dụng trên điện thoại qua kết nối wifi</h5>
<p>
Thông qua ứng dụng POWERbot-E hoặc SmartThings, bạn có thể khởi động hoặc tắt thiết bị, đặt lịch trình làm sạch, điều chỉnh lực hút, điều khiển tốc độ lau,... linh hoạt mọi lúc mọi nơi. Ngoài ra, sản phẩm còn có remote đi kèm cho phép tùy chỉnh thiết bị từ xa dễ dàng, không cần phải trực tiếp thao tác trên thân robot.
</p>
<h5>Hệ thống cảm biến thông minh chuyển động mượt mà, dọn dẹp hiệu quả</h5>
<p>
Robot hút bụi Samsung S65 không trang bị khả năng lưu lại bản đồ, tuy nhiên có cảm biến thông minh giúp kiểm soát chuyển động tinh vi với cảm biến chống va chạm, cảm biến vách tường và cảm biến con quay hồi chuyển cho robot làm sạch mọi ngóc ngách dễ dàng, an toàn cho thiết bị.
</p>
<h5>Hộp chứa bụi dung tích 0.2 lít, hộp chứa nước 0.3 lít, đáp ứng nhu cầu làm sạch hằng ngày</h5>
<p>
Trong đó hộp chứa bụi chuẩn EZ mở ra nhanh chóng chỉ với 1 nút nhấn, có thể tháo rời và làm sạch bằng nước đơn giản.
</p>
<h5>Có nhiều chế độ làm sạch tiện ích</h5>
<p>
Thiết bị có 4 chế độ làm sạch bao gồm chế độ Tự động, chế độ Zigzac, chế độ Edge, chế độ Spot cho bạn tùy chọn theo nhu cầu, hoàn cảnh sử dụng. Bên cạnh đó còn có chế độ lên lịch trình dọn dẹp cho phép người dùng cài đặt nhiều lịch trình để robot tự động vệ sinh vào những thời điểm bạn đã chọn hằng ngày.
</p>
<h5>Kiểu dáng gọn nhẹ, nhỏ nhắn, màu đen lịch lãm, tô điểm cho không gian nội thất sang trọng, cao cấp hơn</h5>
<p>
Tiện tiếp cận các khu vực khó làm sạch như gầm bàn, gầm giường, làm sạch mọi ngóc ngách trong ngôi nhà.
</p>
<p>
Robot hút bụi lau nhà Samsung S65 được làm nhỏ nhắn, thiết kế vừa hút bụi vừa lau sàn tiện lợi, công suất hút tới 4200 Pa cho khả năng làm sạch nhanh chóng, sử dụng đến 150 phút, nhiều chế độ làm sạch, cảm biến thông minh cho robot tự động di chuyển, dọn dẹp dễ dàng, tiện dụng trong gia đình.
</p>
' where id = 65
go

update products set [description] =N'
<h5>Panasonic S66 của thương hiệu Panasonic toàn cầu hơn 100 năm tuổi, sản xuất tại Nhật Bản, yên tâm về chất lượng</h5>
<h5>Nước ion kiềm được chứng nhận có khả năng giảm nhanh, phục hồi các triệu chứng tiêu hóa đường ruột như: tiêu chảy mạn tính, khó tiêu, acid lactic dạ dày, tăng tiết acid</h5>
<p>
- Trung hòa và tiêu diệt các gốc tự do, ROS và RNS, giúp cơ thể phòng ngừa bệnh tật.
<br>
- Giảm căng thẳng giúp thư giãn và hồi phục do hoạt động quá sức.
<br>
- Giúp giảm triệu chứng viêm, đau khớp do các gốc tự do thừa.
<br>
- Kháng viêm, bảo vệ các tổn thương do các gốc tự do gây ra.
</p>
<h5>Công nghệ màng lọc sợi rỗng Nhật Bản loại bỏ hoàn toàn 17 tạp chất</h5>
<h5>Cung cấp 7 loại nước đáp ứng nhu cầu sử dụng hằng ngày gồm 4 mức kiềm, tinh khiết, 2 mức axit nhẹ</h5>
<h5>Công nghệ điện phân với trang bị 5 tấm điện cực titan mạ bạch kim nguyên khối chất lượng cao, sử dụng bền lâu</h5>
<h5>Lọc nước sạch trong mà vẫn giữ được các khoáng chất tự nhiên với hệ thống 1 lõi lọc - 4 cấp, cấu tạo gồm vải không dệt, gốm, than hoạt tính và màng sợi rỗng</h5>
<h5>Thiết kế máy lọc nước thời thượng, nhỏ gọn, sang trọng, chỉ khoảng 2.4 kg, được làm nguyên khối kim loại bóng sáng, giảm tối đa dây thừa</h5>
<h5>Bảng điều khiển tích hợp trên vòi điện tử phím cơ chỉ dẫn tiếng Anh, có đèn báo chế độ nước thông minh, cho bạn dễ dàng quan sát và lấy đúng nước mình cần</h5>
<h5>Tỷ lệ thu hồi nước ion kiềm/ nước thải là 80:20, có nghĩa 10 lít nước lọc cho 8 lít nước ion kiềm và 2 lít nước thải</h5>
<h5>Được tích hợp nhiều tính năng an toàn thông minh, cho máy hoạt động bền hơn</h5>
<p>
Máy lọc nước Ion kiềm Panasonic S66 5 tấm điện cực của thương hiệu thế kỷ Panasonic - Nhật Bản, hỗ trợ công nghệ tiên tiến, hệ thống lọc 4 cấp, công suất lọc lớn mang đến khả năng lọc mạnh mẽ, cung cấp đến 7 loại nước, thỏa mãn mọi nhu cầu về nước cho các thành viên trong gia đình, xứng đáng có mặt trong ngôi nhà Việt.
</p>
' where id = 66
go

update products set [description] =N'
<h5>Máy lọc nước R.O Hydrogen Kangaroo S67 5 lõi thiết kế đẹp mắt, kích cỡ nhỏ gọn, giảm đến 75% lượng nước thải nhờ công nghệ Vortex</h5>
<p>
Công nghệ lọc RO Vortex tiên tiến, tăng tốc độ xoáy và diện tích bề mặt nguồn nước, tối ưu thời gian lõi lọc. Giúp giảm đóng cặn, nâng cao hiệu suất lọc nước cho nguồn nước sau lọc đạt chất lượng.
</p>
Dễ dàng lắp đặt trong nhiều không gian, bạn có thể lắp đặt âm bên dưới tủ bếp, đặt trên mặt kệ bếp, bàn ăn...
</p>
<h5>Cải thiện tốt tình trạng sức khỏe người dùng nhờ cung cấp Hydrogen và khoáng chất</h5>
<h5>Công suất lọc nước đạt 17 lít/giờ, dung tích bình chứa nước 4 lít luôn có nước sạch cho bạn sử dụng mọi lúc</h5>
<h5>Máy có tỷ lệ lọc - thải là 45/55 thu hồi 45% nước tinh khiết</h5>
<h5>Máy lọc nước với 5 lõi lọc nước hiện đại, cung cấp nước sạch, không tạp chất, thêm nhiều khoáng chất, độ ngọt tự nhiên</h5>
<p>
- <b>Lõi PP 5 micron</b>: Loại bỏ tạp chất, cặn bẩn kích thước > 5 micron có trong nước, tăng thời gian sử dụng cho các lõi kết tiếp.
<br>
- <b>Lõi Than hoạt tính dạng xốp</b>: Loại bỏ bụi bẩn thô, Clo, hấp thụ chất hữu cơ dư thừa, các chất khí gây mùi trong nước, kim loại nặng, thuốc trừ sâu, chất gây mùi và các chất oxy hóa gây hỏng màng RO.
<br>
- <b>Lõi PP 1 micron</b>: Loại bỏ tạp chất, cặn bẩn kích thước > 1 micron có trong nước (bùn đất, sạn cát), rong rêu, bảo vệ màng R.O.
<br>
- <b>Màng lọc RO</b>: Lọc sạch ở cấp độ phân tử các ion kim loại nặng, amoni, asen, các chất hữu cơ, vi khuẩn, virus,…
<br>
- <b>Lõi 5 in 1</b>: Công nghệ tạo nước kiềm 5 in 1 - kết hợp lại tạo Hydrogen, PH, độ điện giải (orp), vi khoáng, nano silver. Giúp tạo lượng Hydrogen hàm lượng cao hỗ trợ làm đẹp da, cải thiện hấp thụ dưỡng chất.
</p>
<p>Máy lọc nước Kangaroo S67 5 lõi thiết kế đẹp mắt, lọc nước hiệu quả được nhiều người tin dùng. Máy lọc nước tại vòi thực sự là sự lựa chọn tuyệt vời.
</p>
' where id = 67
go

update products set [description] =N'
<p>
<b>Máy hút bụi không dây Samsung S68 thiết kế không dây di chuyển và làm sạch nhà cửa linh hoạt, quét sạch bụi bẩn nhanh chóng với động cơ Digital Inverter, công nghệ hút đa lốc xoáy Jet Cyclone, có trạm làm sạch 2 trong 1 vừa dùng sạc pin vừa làm sạch bụi bẩn hiệu quả.</b>
</p>
<h5>Tính năng đặc biệt</h5>
<p>
- Máy hút bụi không dây Samsung S68 có thể lau sàn giúp bạn vệ sinh nhà cửa thuận tiện hơn.
</p>
<h5>Thiết kế</h5>
<p>
- Máy hút bụi thiết kế tự đứng, gọn nhẹ, không có dây điện vướng víu cho bạn di chuyển nhẹ nhàng, thoải mái đến mọi vị trí trong nhà. Thiết kế 2 trong 1 có thể tháo rời ống nối giúp bạn dễ dàng vệ sinh các khu vực trên cao thuận tiện hơn.
<br>
- Điều khiển tích hợp trên tay cầm cho bạn tùy chỉnh các mức công suất dễ dàng theo nhu cầu của mình.
</p>
<h5>Thời gian sạc và sử dụng</h5>
<p>
- Máy hút bụi cầm tay sử dụng pin sạc Li-ion, dung lượng pin 5000 mAh sử dụng đến 120 phút ở chế độ thấp, nạp đầy pin trong thời gian 3.5 giờ. Độ bền và hiệu quả sử dụng của pin vẫn duy trì đến 70% sau 5 năm.
</p>
<h5>Công nghệ - Công suất - Độ ồn</h5>
<p>
- Động cơ Digital Inverter với cánh quạt thiết kế 3D siêu âm cho động cơ nhẹ hơn 47% so với bình thường, vận hành êm ái, hút bụi mạnh mẽ. 
<br>
- Độ ồn tối đa 86 dB như âm thanh tiếng ồn trong hội trường, không gây khó chịu cho mọi người xung quanh trong lúc bạn thao tác máy. 
<br>
- Máy hút bụi Samsung hoạt động với công suất 580W, công suất hút đạt 210W giúp hút bụi bẩn nhanh chóng, tiết kiệm điện.
<br>
- Công nghệ hút đa lốc xoáy Jet Cyclone tạo luồng khí hút tối ưu, giảm thiểu hao hụt lực hút cho hiệu quả làm sạch cao. 
<br>
- Trạm làm sạch hỗ trợ công nghệ tạo xung khí Air Pulse tự động loại bỏ bụi bẩn hiệu quả và dễ dàng cho thiết bị. Đồng thời nó cũng là trạm sạc pin, vị trí bảo quản máy gọn gàng.
</p>
<h5>Bộ lọc - Khoang chứa bụi</h5>
<p>
- Bộ lọc đa lớp có khả năng loại bỏ hiệu quả đến 99.999% bụi mịn nhất (PM1.0) và các tác nhân gây dị ứng, đảm bảo bầu không khí trong nhà luôn trong lành, bảo vệ sức khỏe gia đình tốt hơn. 
<br>
- Hộp chứa bụi Bespoke Jet 0.5 lít có thể rửa được bằng nước, túi chứa bụi Clean Station dung tích lớn 2 lít chứa được nhiều bụi bẩn, không cần đổ bụi thường xuyên. Hộp chứa nước dung tích 150 ml lau được bề mặt rộng sau khi châm đầy nước. 
<br>
- Máy hút bụi không dây đi kèm nhiều đầu hút giúp bạn làm sạch mọi ngóc ngách trong nhà dễ dàng: đầu hút sàn, đầu hút thảm, đầu hút bàn chải, đầu hút khe, đầu lau sàn, đầu hút lông thú.
<br>
- Trang bị miếng lau sàn Spray Spinning kháng khuẩn, chống ẩm mốc, có thể tái sử dụng nhiều lần.
</p>
<h5>Tiện ích</h5>
<p>
- Chức năng lau sàn giúp bề mặt sàn nhà sạch sẽ hơn.
<br>
- Màn hình hiển thị trạng thái sạc, trạng thái hoạt động cho bạn dễ dàng theo dõi và sử dụng, nạp pin thiết bị tiện lợi.
<br>
- Trạm làm sạch 2 trong 1 vừa dùng để loại bỏ bụi bẩn vừa sạc pin cho thiết bị tiện lợi.
<br>
- Có hộp chứa phụ kiện giúp cất giữ các phụ kiện ngăn nắp, dễ dàng tìm kiếm khi cần.
<br>
- Điều chỉnh sức hút bụi tùy chỉnh theo nhu cầu sử dụng.
</p>
<p>
Máy hút bụi không dây Samsung S68 thiết kế tinh tế, dễ dàng tiếp cận mọi vị trí trong nhà với kiểu dáng máy không dây, đi kèm nhiều loại đầu hút, đầu lau sàn cho bạn dọn dẹp linh hoạt, hút bụi nhanh chóng với động cơ Digital Inverter, công nghệ hút đa lốc xoáy Jet Cyclone, sức hút 210W, bộ lọc đa lớp loại bỏ được hầu hết bụi mịn, hỗ trợ đa dạng tiện ích như trạm sạc 2 trong 1, điều chỉnh sức hút bụi, màn hình hiển thị trạng thái sạc, hoạt động dễ dàng theo dõi,... chắc chắn sẽ là 1 trợ thủ đắc lực hỗ trợ bạn dọn dẹp nhà cửa.
</p>
' where id = 68
go

SET IDENTITY_INSERT favorites ON
insert into favorites ( id , createdDate , customerId , productId ) values
( 1 , '2021-11-10' , 15 , 45 ) ,
( 2 , '2021-10-21' , 12 , 4 ) ,
( 3 , '2021-12-3' , 10 , 37 ) ,
( 4 , '2021-12-18' , 10 , 3 ) ,
( 5 , '2021-10-16' , 9 , 35 ) ,
( 6 , '2021-11-15' , 16 , 54 ) ,
( 7 , '2022-2-23' , 10 , 2 ) ,
( 8 , '2022-1-11' , 9 , 21 ) ,
( 9 , '2021-10-18' , 8 , 35 ) ,
( 10 , '2022-2-13' , 9 , 36 ) ,
( 11 , '2021-11-13' , 8 , 3 ) ,
( 12 , '2022-2-9' , 10 , 23 ) ,
( 13 , '2022-1-16' , 10 , 31 ) ,
( 14 , '2022-1-14' , 15 , 2 ) ,
( 15 , '2022-2-13' , 8 , 11 ) ,
( 16 , '2022-2-20' , 11 , 49 ) ,
( 17 , '2021-11-5' , 12 , 21 ) ,
( 18 , '2021-11-9' , 12 , 25 ) ,
( 19 , '2021-11-11' , 15 , 13 ) ,
( 20 , '2022-1-17' , 14 , 44 ) ,
( 21 , '2022-1-17' , 8 , 2 ) ,
( 22 , '2022-2-20' , 12 , 45 ) ,
( 23 , '2021-11-7' , 10 , 10 ) ,
( 24 , '2021-11-2' , 16 , 52 ) ,
( 25 , '2022-1-2' , 11 , 34 ) ,
( 26 , '2021-10-25' , 11 , 8 ) ,
( 27 , '2022-1-19' , 9 , 9 ) ,
( 28 , '2021-11-13' , 10 , 41 ) ,
( 29 , '2022-1-16' , 8 , 53 ) ,
( 30 , '2022-2-2' , 15 , 8 ) ,
( 31 , '2021-11-11' , 13 , 28 ) ,
( 32 , '2022-2-12' , 13 , 48 ) ,
( 33 , '2021-12-29' , 9 , 48 ) ,
( 34 , '2022-1-23' , 14 , 1 ) ,
( 35 , '2021-11-26' , 7 , 45 ) ,
( 36 , '2022-1-17' , 14 , 49 ) ,
( 37 , '2022-1-22' , 9 , 8 ) ,
( 38 , '2021-11-9' , 9 , 44 ) ,
( 39 , '2021-10-9' , 9 , 41 ) ,
( 40 , '2022-1-16' , 11 , 55 ) ,
( 41 , '2022-2-13' , 8 , 29 ) ,
( 42 , '2022-2-17' , 12 , 31 ) ,
( 43 , '2021-10-11' , 15 , 42 ) ,
( 44 , '2022-2-27' , 14 , 36 ) ,
( 45 , '2021-11-3' , 13 , 10 ) ,
( 46 , '2021-10-20' , 9 , 4 ) ,
( 47 , '2021-11-24' , 12 , 40 ) ,
( 48 , '2021-10-28' , 7 , 25 ) ,
( 49 , '2021-11-26' , 14 , 53 ) ,
( 50 , '2022-1-14' , 14 , 42 ) ,
( 51 , '2021-12-17' , 14 , 6 ) ,
( 52 , '2021-11-3' , 16 , 8 ) ,
( 53 , '2021-10-11' , 14 , 38 ) ,
( 54 , '2021-11-6' , 12 , 43 ) ,
( 55 , '2022-1-20' , 15 , 39 ) ,
( 56 , '2022-1-20' , 7 , 6 ) ,
( 57 , '2022-2-20' , 13 , 6 ) ,
( 58 , '2021-11-8' , 10 , 49 ) ,
( 59 , '2021-11-16' , 7 , 37 ) ,
( 60 , '2021-11-15' , 12 , 34 ) ,
( 61 , '2022-1-14' , 15 , 20 ) ,
( 62 , '2021-10-24' , 11 , 16 ) ,
( 63 , '2021-12-5' , 15 , 50 ) ,
( 64 , '2021-10-13' , 9 , 39 ) ,
( 65 , '2021-11-13' , 14 , 27 ) ,
( 66 , '2021-11-28' , 12 , 17 ) ,
( 67 , '2022-2-2' , 7 , 26 ) ,
( 68 , '2021-10-18' , 11 , 35 ) ,
( 69 , '2021-11-27' , 8 , 27 ) ,
( 70 , '2022-2-10' , 10 , 32 ) ,
( 71 , '2022-2-2' , 10 , 47 ) ,
( 72 , '2021-12-28' , 7 , 50 ) ,
( 73 , '2022-1-5' , 13 , 4 ) ,
( 74 , '2022-2-12' , 12 , 35 ) ,
( 75 , '2022-2-1' , 13 , 29 ) ,
( 76 , '2022-1-14' , 8 , 52 ) ,
( 77 , '2022-1-15' , 8 , 41 ) ,
( 78 , '2021-11-25' , 13 , 47 ) ,
( 79 , '2022-2-4' , 14 , 16 ) ,
( 80 , '2022-1-10' , 8 , 21 ) ,
( 81 , '2022-1-15' , 16 , 32 ) ,
( 82 , '2022-1-20' , 13 , 38 ) ,
( 83 , '2022-2-14' , 15 , 14 ) ,
( 84 , '2021-10-18' , 14 , 31 ) ,
( 85 , '2022-1-26' , 14 , 10 ) ,
( 86 , '2021-12-28' , 15 , 29 ) ,
( 87 , '2022-1-16' , 14 , 28 ) ,
( 88 , '2022-1-11' , 10 , 7 ) ,
( 89 , '2022-1-8' , 15 , 49 ) ,
( 90 , '2021-12-1' , 9 , 10 ) ,
( 91 , '2022-1-11' , 13 , 34 ) ,
( 92 , '2021-11-18' , 14 , 29 ) ,
( 93 , '2022-1-20' , 15 , 32 ) ,
( 94 , '2021-11-3' , 14 , 5 ) ,
( 95 , '2022-1-17' , 8 , 12 ) ,
( 96 , '2022-2-3' , 8 , 9 ) ,
( 97 , '2021-11-24' , 13 , 20 ) ,
( 98 , '2021-10-7' , 11 , 31 ) ,
( 99 , '2022-1-13' , 12 , 32 ) ,
( 100 , '2022-2-8' , 13 , 27 )
SET IDENTITY_INSERT favorites OFF
go

SET IDENTITY_INSERT orders ON
go
insert into orders( id , receiverFullname , receiverAddress , receiverPhone , createdDate , receivedDate , orderStatusId , shippingFee , customerId , confirmingStaffId , shippingStaffId ) values
( 1 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-6-3' , '2021-6-5', 5 , 102000 , 8 , 3 , 6 ) ,
( 2 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-6-11' , null , -1 , 0 , 7 , null , null ) ,
( 3 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2021-6-11' , '2021-6-12', 5 , 28000 , 10 , 4 , 6 ) ,
( 4 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-6-13' , '2021-6-16' , 5 , 43000 , 8 , 3 , 6 ) ,
( 5 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-6-14' , '2021-6-17' , 5 , 83000 , 8 , 3 , 5 ) ,
( 6 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2021-6-16' , '2021-6-18' , 5 , 46000 , 11 , 3 , 6 ) ,
( 7 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-6-19' , '2021-6-20' , 5 , 44000 , 14 , 3 , 5 ) ,
( 8 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2021-6-25' , '2021-6-27' , 5 , 69000 , 10 , 3 , 5 ) ,
( 9 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-6-23' , '2021-6-24' , 5 , 27000 , 7 , 4 , 5 ) ,
( 10 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-6-24' , '2021-6-25', 5 , 93000 , 14 , 4 , 5 ) ,
( 11 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-6-27' , '2021-6-28' , 5 , 98000 , 14 , 4 , 6 ) ,
( 12 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2021-6-27' , '2021-6-29' , 5 , 43000 , 11 , 3 , 6 ) ,
( 13 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-7-3' , '2021-7-4', 5 , 44000 , 13 , 3 , 6 ) ,
( 14 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-7-4' , null , -1 , 0 , 13 , null , null ) ,
( 15 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237', '2021-7-8' , '2021-7-9', 5 , 60000 , 6 , 4 , 5 ) ,
( 16 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-7-13' , '2021-7-15', 5 , 16000 , 8 , 4 , 5 ) ,
( 17 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-7-14' , '2021-7-15', 5 , 35000 , 8 , 4 , 6 ) ,
( 18 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-7-15' , '2021-7-16', 5 , 48000 , 14 , 3 , 6 ) ,
( 19 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-7-17' , '2021-7-20', 5 , 28000 , 15 , 4 , 6 ) ,
( 20 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2021-7-26' , '2021-7-27', 5 , 45000 , 10 , 4 , 6 ) ,
( 21 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám' , '0936529660' , '2021-8-1' , '2021-8-3', 5 , 14000 , 7 , 3 , 6 ) ,
( 22 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám' , '0936529660' , '2021-8-3' , '2021-8-4', 5 , 75000 , 7 , 4 , 6 ) ,
( 23 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-8-4' , '2021-8-5', 5 , 87000 , 13 , 4 , 6 ) ,
( 24 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-8-15' , '2021-8-17', 5 , 47000 , 8 , 3 , 5 ) ,
( 25 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-8-19' , '2021-8-20', 5 , 94000 , 14 , 4 , 6 ) ,
( 26 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2021-8-25' , null , -1 , 0 , 12 , null , null ) ,
( 27 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-9-3' , null , -1 , 0 , 15 , null , null ) ,
( 28 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-9-6' , '2021-9-8', 5 , 64000 , 13 , 3 , 5 ) ,
( 29 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2021-9-7' , '2021-9-8', 5 , 47000 , 9 , 4 , 6 ) ,
( 30 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-9-8' , '2021-9-9', 5 , 23000 , 13 , 3 , 6 ) ,
( 31 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-9-15' , '2021-9-17', 5 , 101000 , 8 , 4 , 5 ) ,
( 32 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2021-9-17' , '2021-9-18', 5 , 33000 , 10 , 3 , 6 ) ,
( 33 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-9-17' , null , -1 , 0 , 15 , null , null ) ,
( 34 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-9-18' , null , -1 , 0 , 14 , null , null ) ,
( 35 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237', '2021-9-18' , '2021-9-19', 5 , 76000 , 6 , 3 , 6 ) ,
( 36 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-9-20' , '2021-9-21', 5 , 26000 , 13 , 3 , 6 ) ,
( 37 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-9-22' , '2021-9-23', 5 , 38000 , 14 , 3 , 6 ) ,
( 38 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-9-22' , null , -1 , 0 , 7 , null , null ) ,
( 39 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2021-10-15' , '2021-10-17', 5 , 78000 , 12 , 4 , 6 ) ,
( 40 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-10-19' , '2021-10-22', 5 , 100000 , 14 , 3 , 6 ) ,
( 41 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237' , '2021-10-25' , '2021-10-27', 5 , 99000 , 16 , 4 , 5 ) ,
( 42 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2021-11-3' , '2021-11-4', 5 , 26000 , 11 , 4 , 6 ) ,
( 43 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-11-13' , null , -1 , 0 , 15 , null , null ) ,
( 44 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-11-13' , '2021-11-14', 5 , 31000 , 13 , 3 , 5 ) ,
( 45 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2021-11-18' , '2021-11-19', 5 , 80000 , 14 , 4 , 5 ) ,
( 46 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-11-19' , '2021-11-21', 5 , 29000 , 13 , 3 , 6 ) ,
( 47 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-11-23' , '2021-11-24', 5 , 97000 , 13 , 4 , 5 ) ,
( 48 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2021-12-6' , '2021-12-7', 5 , 44000 , 9 , 3 , 6 ) ,
( 49 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-12-8' , '2021-12-10', 5 , 88000 , 7 , 3 , 6 ) ,
( 50 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-12-13' , '2021-12-15', 5 , 103000 , 7 , 4 , 6 ) ,
( 51 , N'Lê Tiến Tài' , N'273 Võ Văn Ngân, TP.Thủ Đức' , '0931062650' , '2021-12-13' , '2021-12-15', 5 , 25000 , 13 , 4 , 6 ) ,
( 52 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237', '2021-12-14' , '2021-12-16', 5 , 71000 , 6 , 3 , 6 ) ,
( 53 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2021-12-14' , '2021-12-16', 5 , 78000 , 12 , 4 , 6 ) ,
( 54 , N'Huỳnh Anh Nhân' , N'463A Cách Mạng Tháng Tám, P.13, Q.10, TP.HCM' , '0936529660' , '2021-12-18' , '2021-12-19', 5 , 41000 , 7 , 3 , 6 ) ,
( 55 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-12-18' , '2021-12-20', 5 , 40000 , 15 , 3 , 5 ) ,
( 56 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2021-12-18' , '2021-12-21', 5 , 74000 , 9 , 4 , 5 ) ,
( 57 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2021-12-23' , '2021-12-25', 5 , 82000 , 15 , 4 , 5 ) ,
( 58 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2021-12-27' , null , -1 , 0 , 8 , null , null ) ,
( 59 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2022-1-3' , '2021-1-5', 5 , 65000 , 8 , 4 , 5 ) ,
( 60 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-1-6' , '2021-1-8', 5 , 76000 , 11 , 3 , 6 ) ,
( 61 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2022-1-7' , '2021-1-8', 5 , 78000 , 8 , 3 , 6 ) ,
( 62 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2022-1-10' , '2021-1-12', 5 , 9000 , 8 , 4 , 6 ) ,
( 63 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-1-12' , '2021-1-13', 5 , 77000 , 10 , 4 , 6 ) ,
( 64 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2022-1-19' , '2021-1-22', 5 , 71000 , 12 , 3 , 5 ) ,
( 65 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2022-1-20' , '2021-1-21', 5 , 43000 , 15 , 4 , 6 ) ,
( 66 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-1-21' , '2021-1-23', 5 , 87000 , 14 , 4 , 5 ) ,
( 67 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-1-23' , '2021-1-24', 5 , 14000 , 11 , 4 , 5 ) ,
( 68 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-1-23' , '2021-1-24', 5 , 10000 , 11 , 3 , 5 ) ,
( 69 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2022-2-2' , '2021-2-4', 5 , 60000 , 9 , 3 , 5 ) ,
( 70 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-2-6' , '2021-2-10', 5 , 56000 , 11 , 4 , 6 ) ,
( 71 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2022-2-8' , '2021-2-10', 5 , 37000 , 8 , 3 , 6 ) ,
( 72 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2022-2-9' , '2021-2-10', 5 , 52000 , 12 , 4 , 6 ) ,
( 73 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-2-15' , '2021-2-16', 5 , 87000 , 10 , 3 , 5 ) ,
( 74 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-2-17' , null , -1 , 0 , 11 , null , null ) ,
( 75 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2022-2-22' , '2021-2-23', 5 , 24000 , 12 , 3 , 6 ) ,
( 76 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-2-22' , '2021-2-23', 5 , 92000 , 10 , 4 , 6 ) ,
( 77 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-2-23' , '2021-2-24', 5 , 66000 , 14 , 4 , 5 ) ,
( 78 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-2-26' , '2021-2-28', 5 , 90000 , 10 , 3 , 6 ) ,
( 79 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-3-1' , '2022-3-2' , 5 , 98000 , 10 , 4 , 5 ) ,
( 80 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-3-4' , '2022-3-5' , 5 , 71000 , 11 , 4 , 5 ) ,
( 81 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-3-9' , '2022-3-11' , 5 , 29000 , 14 , 3 , 6 ) ,
( 82 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-3-13' , '2022-3-15' , 5 , 84000 , 10 , 4 , 6 ) ,
( 83 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2022-3-15' , null , -1 , 0 , 9 , null , null ) ,
( 84 , N'Đỗ Kim Ngân' , N'77 Trần Quang Diệu, Q.3, TP.HCM' , '0931698210' , '2022-3-17' , '2022-3-19' , 5 , 84000 , 8 , 3 , 5 ) ,
( 85 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-3-20' , '2021-3-21', 5 , 69000 , 11 , 4 , 5 ) ,
( 86 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2022-3-22' , '2022-3-23' , 5 , 55000 , 9 , 4 , 6 ) ,
( 87 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2022-3-25' , '2022-3-27' , 5 , 57000 , 15 , 4 , 5 ) ,
( 88 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237' , '2022-4-1' , '2022-4-2' , 5 , 94000 , 16 , 3 , 5 ) ,
( 89 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2022-4-2' , '2022-4-5' , 5 , 78000 , 12 , 4 , 6 ) ,
( 90 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2022-4-20' , '2022-4-22' , 5 , 12000 , 9 , 4 , 5 ) ,
( 91 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237' , '2022-4-20' , '2022-4-23' , 5 , 104000 , 16 , 4 , 6 ) ,
( 92 , N'Võ Nhật Nam' , N'26 Lý Tự Trọng, Q.1, TP.HCM' , '0363922237' , '2022-5-2' , '2022-5-3' , 5 , 14000 , 16 , 3 , 5 ) ,
( 93 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-5-4' , null , 3 , 45000 , 14 , 4 , 6 ) ,
( 94 , N'Đặng Anh Minh' , N'240 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0369206660' , '2022-5-15' , null , 3 , 72000 , 15 , 4 , 5 ) ,
( 95 , N'Huỳnh Trúc Nhân' , N'242 Huỳnh Văn Bánh, Q.Phú Nhuận, TP.HCM' , '0932838520' , '2022-5-16' , null , 1 , 0 , 13 , 3 , null ) ,
( 96 , N'Trần Thái Huy' , N'236 Quang Trung, Q.Gò Vấp, TP.HCM' , '0931119261' , '2022-5-17' , null , 1 , 0 , 14 , 4 , null ) ,
( 97 , N'Lê Văn Tí' , N'Chung cư 42 Tôn Thất Thiệp, Q.1, TP.HCM' , '0386382227' , '2022-5-20' , null , -1 , 0 , 9 , null , null ) ,
( 98 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-5-21' , null , 1 , 0 , 8 , 4 , null ) ,
( 99 , N'Huỳnh Phong' , N'257 Nguyễn Trãi, Q.1, TP.HCM' , '0397007771' , '2022-5-22' , null , 0 , 0 , 7 , null , null ) ,
( 100 , N'Nguyễn Thị Diễm Lệ' , N'25 Trần Quang Diệu, P.14, Q.3, TP.HCM' , '0931056811' , '2022-5-27' , null , 0 , 0 , 14 , null , null )
SET IDENTITY_INSERT orders OFF
go

use G2SHOP
SET IDENTITY_INSERT order_details ON
go

insert into order_details( id , price , quantity , orderId , productId ) values

( 1 , 5990000 , 5 , 1 , 10 ) ,
( 2 , 840000 , 1 , 1 , 2 ) ,
( 3 , 820000 , 1 , 2 , 4 ) ,
( 4 , 20990000 , 5 , 2 , 25 ) ,
( 5 , 820000 , 2 , 2 , 5 ) ,
( 6 , 10190000 , 2 , 2 , 42 ) ,
( 7 , 790000 , 2 , 2 , 14 ) ,
( 8 , 5990000 , 4 , 3 , 10 ) ,
( 9 , 4190000 , 1 , 3 , 21 ) ,
( 10 , 3110000 , 1 , 3 , 28 ) ,
( 11 , 10190000 , 5 , 3 , 42 ) ,
( 12 , 1040000 , 1 , 4 , 22 ) ,
( 13 , 790000 , 1 , 4 , 14 ) ,
( 14 , 1100000 , 4 , 4 , 23 ) ,
( 15 , 1080000 , 3 , 4 , 18 ) ,
( 16 , 3420000 , 4 , 4 , 37 ) ,
( 17 , 950000 , 3 , 5 , 3 ) ,
( 18 , 1490000 , 1 , 5 , 38 ) ,
( 19 , 890000 , 4 , 6 , 6 ) ,
( 20 , 4369000 , 1 , 6 , 7 ) ,
( 21 , 2600000 , 4 , 6 , 30 ) ,
( 22 , 950000 , 3 , 7 , 3 ) ,
( 23 , 2570000 , 3 , 7 , 11 ) ,
( 24 , 2769000 , 1 , 8 , 29 ) ,
( 25 , 22500000 , 4 , 8 , 43 ) ,
( 26 , 1100000 , 4 , 9 , 23 ) ,
( 27 , 840000 , 4 , 10 , 2 ) ,
( 28 , 840000 , 2 , 11 , 2 ) ,
( 29 , 949000 , 4 , 11 , 35 ) ,
( 30 , 19990000 , 4 , 12 , 45 ) ,
( 31 , 950000 , 2 , 12 , 3 ) ,
( 32 , 9900000 , 5 , 12 , 26 ) ,
( 33 , 1080000 , 2 , 13 , 18 ) ,
( 34 , 790000 , 4 , 13 , 14 ) ,
( 35 , 2570000 , 5 , 13 , 11 ) ,
( 36 , 1490000 , 3 , 14 , 38 ) ,
( 37 , 1490000 , 4 , 14 , 17 ) ,
( 38 , 20990000 , 2 , 14 , 25 ) ,
( 39 , 2570000 , 1 , 15 , 11 ) ,
( 40 , 2410000 , 4 , 15 , 32 ) ,
( 41 , 5990000 , 5 , 15 , 10 ) ,
( 42 , 20990000 , 4 , 15 , 25 ) ,
( 43 , 1040000 , 4 , 15 , 22 ) ,
( 44 , 1690000 , 4 , 16 , 20 ) ,
( 45 , 1080000 , 3 , 16 , 18 ) ,
( 46 , 1080000 , 4 , 16 , 15 ) ,
( 47 , 4030000 , 3 , 17 , 19 ) ,
( 48 , 8390000 , 2 , 17 , 40 ) ,
( 49 , 680000 , 1 , 17 , 13 ) ,
( 50 , 680000 , 4 , 17 , 35 ) ,
( 51 , 790000 , 3 , 18 , 14 ) ,
( 52 , 680000 , 5 , 18 , 13 ) ,
( 53 , 4030000 , 1 , 18 , 19 ) ,
( 54 , 3280000 , 4 , 18 , 9 ) ,
( 55 , 700000 , 2 , 18 , 5 ) ,
( 56 , 890000 , 4 , 18 , 34 ) ,
( 57 , 840000 , 3 , 19 , 2 ) ,
( 58 , 3110000 , 2 , 19 , 28 ) ,
( 59 , 22500000 , 1 , 19 , 43 ) ,
( 60 , 8390000 , 4 , 19 , 40 ) ,
( 61 , 3110000 , 3 , 20 , 28 ) ,
( 62 , 1490000 , 3 , 20 , 17 ) ,
( 63 , 510000 , 2 , 20 , 33 ) ,
( 64 , 1859000 , 4 , 21 , 15 ) ,
( 65 , 4050000 , 2 , 21 , 44 ) ,
( 66 , 10190000 , 2 , 21 , 42 ) ,
( 67 , 2769000 , 3 , 22 , 40 ) ,
( 68 , 2769000 , 3 , 22 , 29 ) ,
( 69 , 1040000 , 1 , 22 , 22 ) ,
( 70 , 1859000 , 4 , 22 , 15 ) ,
( 71 , 22500000 , 4 , 22 , 43 ) ,
( 72 , 4190000 , 2 , 23 , 21 ) ,
( 73 , 1990000 , 2 , 23 , 8 ) ,
( 74 , 1890000 , 3 , 23 , 16 ) ,
( 75 , 20990000 , 3 , 24 , 25 ) ,
( 76 , 1890000 , 2 , 24 , 16 ) ,
( 77 , 3420000 , 4 , 25 , 37 ) ,
( 78 , 2769000 , 1 , 25 , 29 ) ,
( 79 , 1450000 , 5 , 26 , 12 ) ,
( 80 , 5990000 , 4 , 26 , 10 ) ,
( 81 , 4030000 , 5 , 26 , 19 ) ,
( 82 , 4190000 , 4 , 26 , 21 ) ,
( 83 , 1690000 , 5 , 27 , 20 ) ,
( 84 , 4310000 , 3 , 27 , 41 ) ,
( 85 , 1490000 , 1 , 28 , 17 ) ,
( 86 , 680000 , 2 , 28 , 13 ) ,
( 87 , 27290000 , 3 , 28 , 24 ) ,
( 88 , 2599000 , 4 , 28 , 31 ) ,
( 89 , 22500000 , 4 , 28 , 43 ) ,
( 90 , 2570000 , 1 , 29 , 11 ) ,
( 91 , 3090000 , 2 , 29 , 27 ) ,
( 92 , 1450000 , 1 , 29 , 12 ) ,
( 93 , 820000 , 2 , 29 , 4 ) ,
( 94 , 950000 , 1 , 30 , 3 ) ,
( 95 , 20990000 , 3 , 30 , 25 ) ,
( 96 , 1490000 , 3 , 30 , 17 ) ,
( 97 , 700000 , 4 , 31 , 5 ) ,
( 98 , 840000 , 5 , 31 , 2 ) ,
( 99 , 3420000 , 4 , 31 , 37 ) ,
( 100 , 790000 , 3 , 31 , 14 ) ,
( 101 , 10190000 , 5 , 31 , 42 ) ,
( 102 , 2570000 , 3 , 31 , 11 ) ,
( 103 , 840000 , 3 , 32 , 2 ) ,
( 104 , 820000 , 1 , 33 , 4 ) ,
( 105 , 1990000 , 4 , 33 , 8 ) ,
( 106 , 2570000 , 2 , 33 , 11 ) ,
( 107 , 4310000 , 2 , 33 , 41 ) ,
( 108 , 1890000 , 3 , 33 , 16 ) ,
( 109 , 4310000 , 1 , 34 , 41 ) ,
( 110 , 840000 , 4 , 34 , 2 ) ,
( 111 , 4190000 , 1 , 34 , 21 ) ,
( 112 , 3110000 , 2 , 34 , 28 ) ,
( 113 , 19990000 , 2 , 35 , 45 ) ,
( 114 , 950000 , 3 , 35 , 3 ) ,
( 115 , 4030000 , 5 , 35 , 19 ) ,
( 116 , 19990000 , 1 , 35 , 22 ) ,
( 117 , 950000 , 3 , 35 , 8 ) ,
( 118 , 4050000 , 4 , 36 , 44 ) ,
( 119 , 1990000 , 4 , 36 , 8 ) ,
( 120 , 2410000 , 2 , 36 , 32 ) ,
( 121 , 9900000 , 3 , 36 , 26 ) ,
( 122 , 700000 , 3 , 37 , 5 ) ,
( 123 , 20990000 , 4 , 37 , 25 ) ,
( 124 , 22500000 , 2 , 37 , 43 ) ,
( 125 , 3090000 , 3 , 37 , 27 ) ,
( 126 , 3280000 , 1 , 37 , 9 ) ,
( 127 , 9900000 , 4 , 38 , 26 ) ,
( 128 , 2769000 , 4 , 38 , 29 ) ,
( 129 , 2410000 , 1 , 38 , 32 ) ,
( 130 , 20990000 , 5 , 38 , 25 ) ,
( 131 , 10190000 , 2 , 38 , 42 ) ,
( 132 , 4310000 , 3 , 38 , 41 ) ,
( 133 , 2570000 , 3 , 39 , 11 ) ,
( 134 , 1380000 , 5 , 39 , 1 ) ,
( 135 , 1859000 , 2 , 39 , 15 ) ,
( 136 , 4190000 , 3 , 39 , 21 ) ,
( 137 , 1800000 , 1 , 39 , 36 ) ,
( 138 , 2410000 , 2 , 40 , 32 ) ,
( 139 , 4050000 , 2 , 41 , 44 ) ,
( 140 , 2570000 , 4 , 42 , 11 ) ,
( 141 , 4050000 , 5 , 42 , 44 ) ,
( 142 , 680000 , 2 , 42 , 13 ) ,
( 143 , 3090000 , 4 , 42 , 27 ) ,
( 144 , 950000 , 3 , 42 , 3 ) ,
( 145 , 1100000 , 4 , 43 , 23 ) ,
( 146 , 2769000 , 5 , 43 , 29 ) ,
( 147 , 790000 , 3 , 43 , 14 ) ,
( 148 , 950000 , 3 , 43 , 3 ) ,
( 149 , 680000 , 2 , 44 , 13 ) ,
( 150 , 3090000 , 3 , 44 , 27 ) ,
( 151 , 3110000 , 3 , 45 , 28 ) ,
( 152 , 1080000 , 5 , 45 , 18 ) ,
( 153 , 3090000 , 2 , 45 , 27 ) ,
( 154 , 1690000 , 2 , 46 , 20 ) ,
( 155 , 2600000 , 2 , 46 , 30 ) ,
( 156 , 1800000 , 3 , 47 , 36 ) ,
( 157 , 1080000 , 3 , 47 , 18 ) ,
( 158 , 22500000 , 2 , 47 , 43 ) ,
( 159 , 4310000 , 4 , 47 , 41 ) ,
( 160 , 1380000 , 2 , 47 , 1 ) ,
( 161 , 4190000 , 1 , 47 , 21 ) ,
( 162 , 3280000 , 2 , 48 , 9 ) ,
( 163 , 10190000 , 1 , 48 , 42 ) ,
( 164 , 1490000 , 4 , 48 , 17 ) ,
( 165 , 1690000 , 2 , 48 , 20 ) ,
( 166 , 1100000 , 4 , 48 , 23 ) ,
( 167 , 1450000 , 2 , 49 , 12 ) ,
( 168 , 9900000 , 3 , 49 , 26 ) ,
( 169 , 700000 , 5 , 49 , 5 ) ,
( 170 , 949000 , 1 , 49 , 35 ) ,
( 171 , 820000 , 4 , 50 , 4 ) ,
( 172 , 3420000 , 2 , 50 , 37 ) ,
( 173 , 1490000 , 1 , 51 , 17 ) ,
( 174 , 890000 , 3 , 51 , 34 ) ,
( 175 , 2570000 , 4 , 51 , 11 ) ,
( 176 , 510000 , 5 , 51 , 33 ) ,
( 177 , 950000 , 3 , 52 , 3 ) ,
( 178 , 3090000 , 3 , 52 , 27 ) ,
( 179 , 10190000 , 1 , 53 , 42 ) ,
( 180 , 1380000 , 4 , 53 , 1 ) ,
( 181 , 2599000 , 2 , 53 , 31 ) ,
( 182 , 950000 , 5 , 53 , 3 ) ,
( 183 , 820000 , 3 , 53 , 4 ) ,
( 184 , 820000 , 3 , 54 , 4 ) ,
( 185 , 890000 , 2 , 54 , 34 ) ,
( 186 , 27290000 , 3 , 54 , 24 ) ,
( 187 , 9900000 , 1 , 55 , 26 ) ,
( 188 , 1380000 , 2 , 55 , 1 ) ,
( 189 , 5990000 , 1 , 55 , 10 ) ,
( 190 , 2599000 , 4 , 55 , 31 ) ,
( 191 , 6824000 , 4 , 55 , 39 ) ,
( 192 , 1450000 , 4 , 55 , 12 ) ,
( 193 , 2600000 , 1 , 56 , 30 ) ,
( 194 , 10190000 , 2 , 57 , 42 ) ,
( 195 , 27290000 , 4 , 57 , 24 ) ,
( 196 , 10190000 , 4 , 57 , 20 ) ,
( 197 , 1040000 , 4 , 58 , 22 ) ,
( 198 , 790000 , 2 , 58 , 14 ) ,
( 199 , 2769000 , 2 , 58 , 29 ) ,
( 200 , 10190000 , 5 , 59 , 42 ) ,
( 201 , 890000 , 4 , 59 , 34 ) ,
( 202 , 820000 , 4 , 59 , 4 ) ,
( 203 , 1490000 , 3 , 60 , 38 ) ,
( 204 , 1080000 , 2 , 60 , 18 ) ,
( 205 , 1490000 , 4 , 61 , 38 ) ,
( 206 , 4310000 , 4 , 61 , 41 ) ,
( 207 , 8390000 , 1 , 61 , 40 ) ,
( 208 , 1890000 , 2 , 62 , 16 ) ,
( 209 , 10190000 , 5 , 63 , 42 ) ,
( 210 , 3420000 , 2 , 63 , 37 ) ,
( 211 , 1490000 , 3 , 64 , 38 ) ,
( 212 , 4030000 , 5 , 64 , 19 ) ,
( 213 , 1490000 , 4 , 65 , 38 ) ,
( 214 , 2599000 , 4 , 65 , 31 ) ,
( 215 , 680000 , 5 , 66 , 13 ) ,
( 216 , 1800000 , 4 , 66 , 36 ) ,
( 217 , 4190000 , 4 , 67 , 21 ) ,
( 218 , 5990000 , 1 , 68 , 10 ) ,
( 219 , 1080000 , 3 , 68 , 18 ) ,
( 220 , 1380000 , 4 , 69 , 1 ) ,
( 221 , 5990000 , 4 , 69 , 10 ) ,
( 222 , 1890000 , 4 , 69 , 16 ) ,
( 223 , 1490000 , 4 , 69 , 38 ) ,
( 224 , 890000 , 3 , 70 , 34 ) ,
( 225 , 950000 , 2 , 70 , 3 ) ,
( 226 , 700000 , 2 , 70 , 5 ) ,
( 227 , 1890000 , 1 , 71 , 16 ) ,
( 228 , 700000 , 3 , 72 , 5 ) ,
( 229 , 890000 , 1 , 72 , 34 ) ,
( 230 , 1890000 , 4 , 72 , 16 ) ,
( 231 , 1490000 , 4 , 72 , 38 ) ,
( 232 , 4369000 , 3 , 73 , 7 ) ,
( 233 , 700000 , 3 , 73 , 5 ) ,
( 234 , 3420000 , 2 , 73 , 42 ) ,
( 235 , 3420000 , 2 , 73 , 37 ) ,
( 236 , 3420000 , 3 , 74 , 37 ) ,
( 237 , 1380000 , 1 , 74 , 1 ) ,
( 238 , 1800000 , 4 , 74 , 36 ) ,
( 239 , 5990000 , 1 , 74 , 10 ) ,
( 240 , 4190000 , 5 , 74 , 21 ) ,
( 241 , 1490000 , 2 , 75 , 38 ) ,
( 242 , 3110000 , 2 , 75 , 28 ) ,
( 243 , 950000 , 2 , 75 , 3 ) ,
( 244 , 2410000 , 4 , 76 , 32 ) ,
( 245 , 949000 , 4 , 76 , 35 ) ,
( 246 , 1490000 , 3 , 76 , 38 ) ,
( 247 , 2769000 , 3 , 76 , 29 ) ,
( 248 , 2600000 , 4 , 76 , 30 ) ,
( 249 , 2600000 , 3 , 77 , 30 ) ,
( 250 , 3090000 , 3 , 77 , 27 ) ,
( 251 , 10190000 , 4 , 77 , 42 ) ,
( 252 , 8390000 , 3 , 78 , 40 ) ,
( 253 , 27290000 , 3 , 78 , 24 ) ,
( 254 , 1690000 , 2 , 78 , 20 ) ,
( 255 , 1990000 , 3 , 78 , 8 ) ,
( 256 , 1490000 , 2 , 79 , 38 ) ,
( 257 , 2599000 , 5 , 79 , 31 ) ,
( 258 , 4190000 , 2 , 79 , 21 ) ,
( 259 , 680000 , 3 , 79 , 13 ) ,
( 260 , 3280000 , 5 , 79 , 9 ) ,
( 261 , 2410000 , 2 , 80 , 32 ) ,
( 262 , 3090000 , 3 , 80 , 27 ) ,
( 263 , 22500000 , 4 , 81 , 43 ) ,
( 264 , 9900000 , 2 , 81 , 26 ) ,
( 265 , 4050000 , 2 , 81 , 44 ) ,
( 266 , 3090000 , 4 , 82 , 27 ) ,
( 267 , 820000 , 3 , 82 , 4 ) ,
( 268 , 20990000 , 3 , 82 , 25 ) ,
( 269 , 4030000 , 2 , 82 , 19 ) ,
( 270 , 820000 , 5 , 82 , 10 ) ,
( 271 , 890000 , 4 , 83 , 34 ) ,
( 272 , 1040000 , 3 , 83 , 22 ) ,
( 273 , 1859000 , 5 , 83 , 15 ) ,
( 274 , 4369000 , 2 , 83 , 7 ) ,
( 275 , 700000 , 2 , 83 , 5 ) ,
( 276 , 3110000 , 2 , 84 , 28 ) ,
( 277 , 6824000 , 4 , 84 , 39 ) ,
( 278 , 790000 , 3 , 84 , 14 ) ,
( 279 , 2410000 , 2 , 84 , 32 ) ,
( 280 , 3110000 , 4 , 85 , 28 ) ,
( 281 , 4190000 , 3 , 85 , 21 ) ,
( 282 , 1450000 , 4 , 85 , 12 ) ,
( 283 , 1040000 , 2 , 85 , 22 ) ,
( 284 , 3420000 , 2 , 86 , 37 ) ,
( 285 , 950000 , 3 , 86 , 3 ) ,
( 286 , 3110000 , 4 , 86 , 28 ) ,
( 287 , 4030000 , 1 , 86 , 19 ) ,
( 288 , 4369000 , 4 , 87 , 7 ) ,
( 289 , 4050000 , 3 , 87 , 44 ) ,
( 290 , 890000 , 1 , 87 , 34 ) ,
( 291 , 3110000 , 3 , 87 , 28 ) ,
( 292 , 4030000 , 2 , 88 , 19 ) ,
( 293 , 4310000 , 4 , 88 , 41 ) ,
( 294 , 3280000 , 3 , 88 , 9 ) ,
( 295 , 4050000 , 2 , 88 , 44 ) ,
( 296 , 820000 , 2 , 88 , 4 ) ,
( 297 , 4030000 , 2 , 89 , 19 ) ,
( 298 , 6824000 , 2 , 90 , 39 ) ,
( 299 , 4190000 , 5 , 91 , 21 ) ,
( 300 , 3110000 , 4 , 91 , 28 ) ,
( 301 , 4190000 , 5 , 92 , 21 ) ,
( 302 , 6824000 , 4 , 92 , 39 ) ,
( 303 , 10190000 , 1 , 92 , 42 ) ,
( 304 , 950000 , 2 , 93 , 3 ) ,
( 305 , 27290000 , 2 , 94 , 24 ) ,
( 306 , 1800000 , 1 , 94 , 36 ) ,
( 307 , 1490000 , 1 , 94 , 38 ) ,
( 308 , 3090000 , 2 , 94 , 27 ) ,
( 309 , 4030000 , 2 , 94 , 19 ) ,
( 310 , 890000 , 2 , 95 , 6 ) ,
( 311 , 4050000 , 4 , 95 , 44 ) ,
( 312 , 8390000 , 2 , 95 , 40 ) ,
( 313 , 1490000 , 2 , 96 , 17 ) ,
( 314 , 1690000 , 4 , 96 , 20 ) ,
( 315 , 3110000 , 2 , 96 , 28 ) ,
( 316 , 790000 , 5 , 96 , 14 ) ,
( 317 , 2410000 , 3 , 96 , 32 ) ,
( 318 , 1100000 , 4 , 97 , 23 ) ,
( 319 , 4310000 , 2 , 97 , 41 ) ,
( 320 , 820000 , 3 , 97 , 4 ) ,
( 321 , 840000 , 4 , 97 , 2 ) ,
( 322 , 3420000 , 2 , 97 , 37 ) ,
( 323 , 1380000 , 2 , 97 , 1 ) ,
( 324 , 2599000 , 4 , 98 , 31 ) ,
( 325 , 890000 , 2 , 98 , 34 ) ,
( 326 , 1859000 , 5 , 98 , 15 ) ,
( 327 , 1890000 , 3 , 98 , 16 ) ,
( 328 , 1890000 , 1 , 98 , 20 ) ,
( 329 , 10190000 , 2 , 99 , 42 ) ,
( 330 , 1859000 , 3 , 99 , 15 ) ,
( 331 , 680000 , 1 , 99 , 13 ) ,
( 332 , 790000 , 4 , 99 , 14 ) ,
( 333 , 4050000 , 1 , 99 , 44 ) ,
( 334 , 510000 , 2 , 100 , 33 ) ,
( 335 , 2570000 , 2 , 100 , 11 ) ,
( 336 , 510000 , 4 , 100 , 35 ) ,
( 337 , 1080000 , 4 , 100 , 18 )
SET IDENTITY_INSERT order_details OFF
go

SET IDENTITY_INSERT basic_information ON
insert into basic_information ( id , title , phone , phone2 , email , [address] , embedAddressCode , embedHelpYoutubeVideoIds , termsAndPolicies ) values
( 1	, 
N'CHUYÊN ĐỒ ĐIỆN MÁY - ĐIỆN TỬ GIA DỤNG' ,
'0337089293' , 
'0332619549' , 
'g2shop@gmail.com' , 
N'74 Lê Thị Nho, KP2, Phường Trung Mỹ Tây, Quận 12, Thành phố Hồ Chí Minh' , 
N'<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.4865023317425!2d106.62110721487085!3d10.850553460787983!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752a267ff1e467%3A0x163b4eaa5d42292!2zNzQgxJAuIEzDqiBUaOG7iyBOaG8sIFRydW5nIE3hu7kgVMOieSwgUXXhuq1uIDEyLCBUaMOgbmggcGjhu5EgSOG7kyBDaMOtIE1pbmgsIFZpZXRuYW0!5e0!3m2!1sen!2s!4v1668597617181!5m2!1sen!2s" class= "w-100" height="250" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>' ,
'x_BR9ANwC0I; Ew4395VgtnI; _dhNP3DoBSM; -2bm_Cy8O4k; hA3YZlkh0cg; yV01m63ouQA' ,
N'
<h5>1. Điều kiện sử dụng</h5>
<p>
1.1  Bằng việc truy cập vào website G2Shop, Quý khách đồng ý với các điều khoản và chính sách bên dưới. Xin vui lòng đọc kỹ các điều kiện này.
</p>
<p>
1.2  Nếu Quý khách không đồng ý với các Điều Khoản Sử Dụng này, Quý khách không được truy cập, cung cấp thông tin hay thực hiện bất kỳ hành vi nào trên website.
</p>
<p>
1.3  Chúng tôi có thể điều chỉnh các Điều Khoản và chính sách này vào bất kỳ lúc nào mà không cần phải thông báo cho Quý khách hay đưa ra bất kỳ lý do gì. Đề nghị Quý khách nên thường truy cập vào mục này để kiểm tra sự thay đổi của các điều khoản và chính sách. Trong trường hợp có thay đổi, Quý khách cần tuân thủ với các điều chỉnh và cập nhật. Nếu Quý khách không đồng ý với các điều chỉnh và cập nhật, Quý khách phải ngay lập tức ngừng việc truy cập vào website.
</p>
<h5>2. Điều khoản 1...</h5>
<h5>3. Điều khoản 2...</h5>
<h5>4. Điều khoản 3...</h5>
<h5>5. Chính sách 1...</h5>
<h5>6. Chính sách 2...</h5>
<h5>7. Chính sách 3...</h5>
'
)
SET IDENTITY_INSERT basic_information OFF 
go

SET IDENTITY_INSERT website_visits ON
insert into website_visits ( id , [date], visitCount ) values
( 1 , '2021-6-1' , 12 ) ,
( 2 , '2021-6-2' , 129 ) ,
( 3 , '2021-6-3' , 108 ) ,
( 4 , '2021-6-4' , 194 ) ,
( 5 , '2021-6-5' , 55 ) ,
( 6 , '2021-6-6' , 194 ) ,
( 7 , '2021-6-7' , 188 ) ,
( 8 , '2021-6-8' , 169 ) ,
( 9 , '2021-6-9' , 47 ) ,
( 10 , '2021-6-10' , 65 ) ,
( 11 , '2021-6-11' , 142 ) ,
( 12 , '2021-6-12' , 46 ) ,
( 13 , '2021-6-13' , 192 ) ,
( 14 , '2021-6-14' , 26 ) ,
( 15 , '2021-6-15' , 91 ) ,
( 16 , '2021-6-16' , 82 ) ,
( 17 , '2021-6-17' , 170 ) ,
( 18 , '2021-6-18' , 86 ) ,
( 19 , '2021-6-19' , 90 ) ,
( 20 , '2021-6-20' , 129 ) ,
( 21 , '2021-6-21' , 200 ) ,
( 22 , '2021-6-22' , 177 ) ,
( 23 , '2021-6-23' , 143 ) ,
( 24 , '2021-6-24' , 150 ) ,
( 25 , '2021-6-25' , 134 ) ,
( 26 , '2021-6-26' , 39 ) ,
( 27 , '2021-6-27' , 179 ) ,
( 28 , '2021-6-28' , 74 ) ,
( 29 , '2021-6-29' , 31 ) ,
( 30 , '2021-6-30' , 178 ) ,
( 31 , '2021-7-1' , 80 ) ,
( 32 , '2021-7-2' , 166 ) ,
( 33 , '2021-7-3' , 190 ) ,
( 34 , '2021-7-4' , 48 ) ,
( 35 , '2021-7-5' , 187 ) ,
( 36 , '2021-7-6' , 197 ) ,
( 37 , '2021-7-7' , 47 ) ,
( 38 , '2021-7-8' , 32 ) ,
( 39 , '2021-7-9' , 102 ) ,
( 40 , '2021-7-10' , 162 ) ,
( 41 , '2021-7-11' , 92 ) ,
( 42 , '2021-7-12' , 122 ) ,
( 43 , '2021-7-13' , 144 ) ,
( 44 , '2021-7-14' , 116 ) ,
( 45 , '2021-7-15' , 171 ) ,
( 46 , '2021-7-16' , 93 ) ,
( 47 , '2021-7-17' , 159 ) ,
( 48 , '2021-7-18' , 71 ) ,
( 49 , '2021-7-19' , 88 ) ,
( 50 , '2021-7-20' , 28 ) ,
( 51 , '2021-7-21' , 44 ) ,
( 52 , '2021-7-22' , 120 ) ,
( 53 , '2021-7-23' , 40 ) ,
( 54 , '2021-7-24' , 130 ) ,
( 55 , '2021-7-25' , 162 ) ,
( 56 , '2021-7-26' , 162 ) ,
( 57 , '2021-7-27' , 22 ) ,
( 58 , '2021-7-28' , 119 ) ,
( 59 , '2021-7-29' , 110 ) ,
( 60 , '2021-7-30' , 23 ) ,
( 61 , '2021-7-31' , 132 ) ,
( 62 , '2021-8-1' , 206 ) ,
( 63 , '2021-8-2' , 75 ) ,
( 64 , '2021-8-3' , 118 ) ,
( 65 , '2021-8-4' , 148 ) ,
( 66 , '2021-8-5' , 87 ) ,
( 67 , '2021-8-6' , 106 ) ,
( 68 , '2021-8-7' , 119 ) ,
( 69 , '2021-8-8' , 168 ) ,
( 70 , '2021-8-9' , 71 ) ,
( 71 , '2021-8-10' , 210 ) ,
( 72 , '2021-8-11' , 51 ) ,
( 73 , '2021-8-12' , 145 ) ,
( 74 , '2021-8-13' , 167 ) ,
( 75 , '2021-8-14' , 209 ) ,
( 76 , '2021-8-15' , 34 ) ,
( 77 , '2021-8-16' , 177 ) ,
( 78 , '2021-8-17' , 200 ) ,
( 79 , '2021-8-18' , 95 ) ,
( 80 , '2021-8-19' , 21 ) ,
( 81 , '2021-8-20' , 169 ) ,
( 82 , '2021-8-21' , 13 ) ,
( 83 , '2021-8-22' , 137 ) ,
( 84 , '2021-8-23' , 47 ) ,
( 85 , '2021-8-24' , 144 ) ,
( 86 , '2021-8-25' , 128 ) ,
( 87 , '2021-8-26' , 155 ) ,
( 88 , '2021-8-27' , 125 ) ,
( 89 , '2021-8-28' , 98 ) ,
( 90 , '2021-8-29' , 44 ) ,
( 91 , '2021-8-30' , 160 ) ,
( 92 , '2021-8-31' , 101 ) ,
( 93 , '2021-9-1' , 167 ) ,
( 94 , '2021-9-2' , 50 ) ,
( 95 , '2021-9-3' , 173 ) ,
( 96 , '2021-9-4' , 169 ) ,
( 97 , '2021-9-5' , 104 ) ,
( 98 , '2021-9-6' , 151 ) ,
( 99 , '2021-9-7' , 135 ) ,
( 100 , '2021-9-8' , 103 ) ,
( 101 , '2021-9-9' , 156 ) ,
( 102 , '2021-9-10' , 64 ) ,
( 103 , '2021-9-11' , 64 ) ,
( 104 , '2021-9-12' , 155 ) ,
( 105 , '2021-9-13' , 196 ) ,
( 106 , '2021-9-14' , 194 ) ,
( 107 , '2021-9-15' , 28 ) ,
( 108 , '2021-9-16' , 149 ) ,
( 109 , '2021-9-17' , 124 ) ,
( 110 , '2021-9-18' , 164 ) ,
( 111 , '2021-9-19' , 155 ) ,
( 112 , '2021-9-20' , 63 ) ,
( 113 , '2021-9-21' , 86 ) ,
( 114 , '2021-9-22' , 48 ) ,
( 115 , '2021-9-23' , 153 ) ,
( 116 , '2021-9-24' , 133 ) ,
( 117 , '2021-9-25' , 33 ) ,
( 118 , '2021-9-26' , 148 ) ,
( 119 , '2021-9-27' , 157 ) ,
( 120 , '2021-9-28' , 208 ) ,
( 121 , '2021-9-29' , 44 ) ,
( 122 , '2021-9-30' , 14 ) ,
( 123 , '2021-10-1' , 121 ) ,
( 124 , '2021-10-2' , 146 ) ,
( 125 , '2021-10-3' , 33 ) ,
( 126 , '2021-10-4' , 66 ) ,
( 127 , '2021-10-5' , 121 ) ,
( 128 , '2021-10-6' , 120 ) ,
( 129 , '2021-10-7' , 80 ) ,
( 130 , '2021-10-8' , 48 ) ,
( 131 , '2021-10-9' , 55 ) ,
( 132 , '2021-10-10' , 146 ) ,
( 133 , '2021-10-11' , 149 ) ,
( 134 , '2021-10-12' , 176 ) ,
( 135 , '2021-10-13' , 59 ) ,
( 136 , '2021-10-14' , 197 ) ,
( 137 , '2021-10-15' , 106 ) ,
( 138 , '2021-10-16' , 69 ) ,
( 139 , '2021-10-17' , 184 ) ,
( 140 , '2021-10-18' , 133 ) ,
( 141 , '2021-10-19' , 77 ) ,
( 142 , '2021-10-20' , 65 ) ,
( 143 , '2021-10-21' , 124 ) ,
( 144 , '2021-10-22' , 85 ) ,
( 145 , '2021-10-23' , 183 ) ,
( 146 , '2021-10-24' , 100 ) ,
( 147 , '2021-10-25' , 94 ) ,
( 148 , '2021-10-26' , 148 ) ,
( 149 , '2021-10-27' , 64 ) ,
( 150 , '2021-10-28' , 114 ) ,
( 151 , '2021-10-29' , 13 ) ,
( 152 , '2021-10-30' , 127 ) ,
( 153 , '2021-10-31' , 25 ) ,
( 154 , '2021-11-1' , 85 ) ,
( 155 , '2021-11-2' , 155 ) ,
( 156 , '2021-11-3' , 52 ) ,
( 157 , '2021-11-4' , 171 ) ,
( 158 , '2021-11-5' , 176 ) ,
( 159 , '2021-11-6' , 149 ) ,
( 160 , '2021-11-7' , 62 ) ,
( 161 , '2021-11-8' , 65 ) ,
( 162 , '2021-11-9' , 199 ) ,
( 163 , '2021-11-10' , 194 ) ,
( 164 , '2021-11-11' , 91 ) ,
( 165 , '2021-11-12' , 142 ) ,
( 166 , '2021-11-13' , 32 ) ,
( 167 , '2021-11-14' , 57 ) ,
( 168 , '2021-11-15' , 189 ) ,
( 169 , '2021-11-16' , 51 ) ,
( 170 , '2021-11-17' , 91 ) ,
( 171 , '2021-11-18' , 61 ) ,
( 172 , '2021-11-19' , 105 ) ,
( 173 , '2021-11-20' , 72 ) ,
( 174 , '2021-11-21' , 45 ) ,
( 175 , '2021-11-22' , 108 ) ,
( 176 , '2021-11-23' , 153 ) ,
( 177 , '2021-11-24' , 136 ) ,
( 178 , '2021-11-25' , 113 ) ,
( 179 , '2021-11-26' , 145 ) ,
( 180 , '2021-11-27' , 127 ) ,
( 181 , '2021-11-28' , 134 ) ,
( 182 , '2021-11-29' , 205 ) ,
( 183 , '2021-11-30' , 62 ) ,
( 184 , '2021-12-1' , 137 ) ,
( 185 , '2021-12-2' , 94 ) ,
( 186 , '2021-12-3' , 24 ) ,
( 187 , '2021-12-4' , 138 ) ,
( 188 , '2021-12-5' , 61 ) ,
( 189 , '2021-12-6' , 108 ) ,
( 190 , '2021-12-7' , 139 ) ,
( 191 , '2021-12-8' , 134 ) ,
( 192 , '2021-12-9' , 27 ) ,
( 193 , '2021-12-10' , 207 ) ,
( 194 , '2021-12-11' , 123 ) ,
( 195 , '2021-12-12' , 39 ) ,
( 196 , '2021-12-13' , 187 ) ,
( 197 , '2021-12-14' , 109 ) ,
( 198 , '2021-12-15' , 161 ) ,
( 199 , '2021-12-16' , 112 ) ,
( 200 , '2021-12-17' , 49 ) ,
( 201 , '2021-12-18' , 184 ) ,
( 202 , '2021-12-19' , 137 ) ,
( 203 , '2021-12-20' , 48 ) ,
( 204 , '2021-12-21' , 185 ) ,
( 205 , '2021-12-22' , 182 ) ,
( 206 , '2021-12-23' , 89 ) ,
( 207 , '2021-12-24' , 104 ) ,
( 208 , '2021-12-25' , 108 ) ,
( 209 , '2021-12-26' , 183 ) ,
( 210 , '2021-12-27' , 137 ) ,
( 211 , '2021-12-28' , 171 ) ,
( 212 , '2021-12-29' , 94 ) ,
( 213 , '2021-12-30' , 206 ) ,
( 214 , '2021-12-31' , 52 ) ,
( 215 , '2022-1-1' , 60 ) ,
( 216 , '2022-1-2' , 107 ) ,
( 217 , '2022-1-3' , 154 ) ,
( 218 , '2022-1-4' , 75 ) ,
( 219 , '2022-1-5' , 190 ) ,
( 220 , '2022-1-6' , 143 ) ,
( 221 , '2022-1-7' , 105 ) ,
( 222 , '2022-1-8' , 170 ) ,
( 223 , '2022-1-9' , 25 ) ,
( 224 , '2022-1-10' , 41 ) ,
( 225 , '2022-1-11' , 155 ) ,
( 226 , '2022-1-12' , 197 ) ,
( 227 , '2022-1-13' , 122 ) ,
( 228 , '2022-1-14' , 208 ) ,
( 229 , '2022-1-15' , 204 ) ,
( 230 , '2022-1-16' , 105 ) ,
( 231 , '2022-1-17' , 131 ) ,
( 232 , '2022-1-18' , 111 ) ,
( 233 , '2022-1-19' , 133 ) ,
( 234 , '2022-1-20' , 101 ) ,
( 235 , '2022-1-21' , 203 ) ,
( 236 , '2022-1-22' , 148 ) ,
( 237 , '2022-1-23' , 204 ) ,
( 238 , '2022-1-24' , 171 ) ,
( 239 , '2022-1-25' , 71 ) ,
( 240 , '2022-1-26' , 154 ) ,
( 241 , '2022-1-27' , 137 ) ,
( 242 , '2022-1-28' , 74 ) ,
( 243 , '2022-1-29' , 18 ) ,
( 244 , '2022-1-30' , 199 ) ,
( 245 , '2022-1-31' , 74 ) ,
( 246 , '2022-2-1' , 36 ) ,
( 247 , '2022-2-2' , 177 ) ,
( 248 , '2022-2-3' , 10 ) ,
( 249 , '2022-2-4' , 76 ) ,
( 250 , '2022-2-5' , 22 ) ,
( 251 , '2022-2-6' , 56 ) ,
( 252 , '2022-2-7' , 202 ) ,
( 253 , '2022-2-8' , 118 ) ,
( 254 , '2022-2-9' , 164 ) ,
( 255 , '2022-2-10' , 124 ) ,
( 256 , '2022-2-11' , 155 ) ,
( 257 , '2022-2-12' , 192 ) ,
( 258 , '2022-2-13' , 103 ) ,
( 259 , '2022-2-14' , 208 ) ,
( 260 , '2022-2-15' , 99 ) ,
( 261 , '2022-2-16' , 144 ) ,
( 262 , '2022-2-17' , 98 ) ,
( 263 , '2022-2-18' , 90 ) ,
( 264 , '2022-2-19' , 62 ) ,
( 265 , '2022-2-20' , 208 ) ,
( 266 , '2022-2-21' , 145 ) ,
( 267 , '2022-2-22' , 19 ) ,
( 268 , '2022-2-23' , 153 ) ,
( 269 , '2022-2-24' , 130 ) ,
( 270 , '2022-2-25' , 122 ) ,
( 271 , '2022-2-26' , 138 ) ,
( 272 , '2022-2-27' , 65 ) ,
( 273 , '2022-2-28' , 141 ) ,
( 274 , '2022-3-1' , 94 ) ,
( 275 , '2022-3-2' , 25 ) ,
( 276 , '2022-3-3' , 153 ) ,
( 277 , '2022-3-4' , 207 ) ,
( 278 , '2022-3-5' , 127 ) ,
( 279 , '2022-3-6' , 31 ) ,
( 280 , '2022-3-7' , 46 ) ,
( 281 , '2022-3-8' , 209 ) ,
( 282 , '2022-3-9' , 147 ) ,
( 283 , '2022-3-10' , 180 ) ,
( 284 , '2022-3-11' , 202 ) ,
( 285 , '2022-3-12' , 56 ) ,
( 286 , '2022-3-13' , 89 ) ,
( 287 , '2022-3-14' , 164 ) ,
( 288 , '2022-3-15' , 206 ) ,
( 289 , '2022-3-16' , 19 ) ,
( 290 , '2022-3-17' , 118 ) ,
( 291 , '2022-3-18' , 155 ) ,
( 292 , '2022-3-19' , 115 ) ,
( 293 , '2022-3-20' , 151 ) ,
( 294 , '2022-3-21' , 110 ) ,
( 295 , '2022-3-22' , 35 ) ,
( 296 , '2022-3-23' , 67 ) ,
( 297 , '2022-3-24' , 95 ) ,
( 298 , '2022-3-25' , 77 ) ,
( 299 , '2022-3-26' , 208 ) ,
( 300 , '2022-3-27' , 158 ) ,
( 301 , '2022-3-28' , 129 ) ,
( 302 , '2022-3-29' , 136 ) ,
( 303 , '2022-3-30' , 89 ) ,
( 304 , '2022-3-31' , 28 ) ,
( 305 , '2022-4-1' , 198 ) ,
( 306 , '2022-4-2' , 179 ) ,
( 307 , '2022-4-3' , 163 ) ,
( 308 , '2022-4-4' , 117 ) ,
( 309 , '2022-4-5' , 87 ) ,
( 310 , '2022-4-6' , 52 ) ,
( 311 , '2022-4-7' , 175 ) ,
( 312 , '2022-4-8' , 144 ) ,
( 313 , '2022-4-9' , 81 ) ,
( 314 , '2022-4-10' , 63 ) ,
( 315 , '2022-4-11' , 172 ) ,
( 316 , '2022-4-12' , 57 ) ,
( 317 , '2022-4-13' , 111 ) ,
( 318 , '2022-4-14' , 194 ) ,
( 319 , '2022-4-15' , 140 ) ,
( 320 , '2022-4-16' , 39 ) ,
( 321 , '2022-4-17' , 72 ) ,
( 322 , '2022-4-18' , 155 ) ,
( 323 , '2022-4-19' , 198 ) ,
( 324 , '2022-4-20' , 144 ) ,
( 325 , '2022-4-21' , 176 ) ,
( 326 , '2022-4-22' , 175 ) ,
( 327 , '2022-4-23' , 84 ) ,
( 328 , '2022-4-24' , 149 ) ,
( 329 , '2022-4-25' , 207 ) ,
( 330 , '2022-4-26' , 62 ) ,
( 331 , '2022-4-27' , 57 ) ,
( 332 , '2022-4-28' , 56 ) ,
( 333 , '2022-4-29' , 124 ) ,
( 334 , '2022-4-30' , 120 ) ,
( 335 , '2022-5-1' , 183 ) ,
( 336 , '2022-5-2' , 184 ) ,
( 337 , '2022-5-3' , 120 ) ,
( 338 , '2022-5-4' , 136 ) ,
( 339 , '2022-5-5' , 13 ) ,
( 340 , '2022-5-6' , 83 ) ,
( 341 , '2022-5-7' , 97 ) ,
( 342 , '2022-5-8' , 156 ) ,
( 343 , '2022-5-9' , 149 ) ,
( 344 , '2022-5-10' , 73 ) ,
( 345 , '2022-5-11' , 86 ) ,
( 346 , '2022-5-12' , 200 ) ,
( 347 , '2022-5-13' , 43 ) ,
( 348 , '2022-5-14' , 159 ) ,
( 349 , '2022-5-15' , 47 ) ,
( 350 , '2022-5-16' , 90 ) ,
( 351 , '2022-5-17' , 113 ) ,
( 352 , '2022-5-18' , 141 ) ,
( 353 , '2022-5-19' , 12 ) ,
( 354 , '2022-5-20' , 100 ) ,
( 355 , '2022-5-21' , 63 ) ,
( 356 , '2022-5-22' , 189 ) ,
( 357 , '2022-5-23' , 159 ) ,
( 358 , '2022-5-24' , 12 ) ,
( 359 , '2022-5-25' , 63 ) ,
( 360 , '2022-5-26' , 126 ) ,
( 361 , '2022-5-27' , 81 ) ,
( 362 , '2022-5-28' , 74 ) ,
( 363 , '2022-5-29' , 123 ) ,
( 364 , '2022-5-30' , 23 ) ,
( 365 , '2022-5-31' , 151 )
SET IDENTITY_INSERT website_visits OFF 
go

SET IDENTITY_INSERT news ON
insert into news ( id , title , imageName , content ) values

( 1 , N'5 Lý do bạn nên mua nồi cơm điện tử sử dụng trong gia đình' , '1.jpg' ,
N'
<p>
Trên thị trường hiện nay có rất nhiều dòng sản phẩm nồi cơm điện gia đình, mỗi sản phẩm sẽ phù hợp với các đối tượng khách hàng khác nhau. Bên cạnh những nồi cơm điện truyền thống chỉ có chức năng nấu và giữ ấm cơm là dòng nồi cơm điện tử đa dạng chức năng giúp công việc bếp núc của người nội trợ trở nên dễ dàng hơn.
</p>
<p>
<b>Vậy tại sao bạn nên mua ngay cho gia đình mình một chiếc nồi cơm điện tử?</b>
</p>
<h5>1. Thiết kế hiện đại, sang trọng</h5>
<p>
Nồi cơm điện tử thu hút người tiêu dùng với vẻ ngoài sang trọng từ đường nét thiết kế đến màu sắc tinh tế.
</p>
<p>
Bảng điều khiển nút nhấn điện tử kèm màn hình LCD hiển thị hiện đại, dễ thao tác, hỗ trợ tốt nhất cho người dùng trong việc lựa chọn chức năng và quan sát quá trình nấu với nồi cơm điện.
</p>
<h5>
2. Kết hợp nhiều tính năng hữu ích
</h5>
<p>
Đặc điểm khác biệt nổi bật giữa dòng nồi cơm điện thường và nồi cơm điện tử là nếu nồi cơm điện thường chỉ có 2 chế độ “nấu – Cook” và “hâm nóng – Warm” được tự động điều chỉnh nhờ cảm biến nhiệt thì nồi cơm điện tử có nhiều tính năng tiện ích hỗ trợ cực kỳ hữu ích cho người dùng: chế độ hẹn giờ nấu, chế độ nấu tự động theo thực đơn được cài đặt sẵn…
</p>
<p>
Với nồi cơm điện tử, người dùng có thể chủ động hơn và rảnh tay hơn trong việc nội trợ, thực sự có ích cho các gia đình bận rộn, ít thời gian cho việc bếp núc.
</p>
<h5>
3. Đa dạng chức năng nấu
</h5>
<p>
Nồi cơm điện tử ngoài nấu cơm còn có chức năng nấu cháo, soup, làm bánh, nấu nhanh, nấu chậm, nấu các loại gạo khác nhau… với các chế độ nấu được cài đặt trước giúp món ăn chế biến đơn giản hơn, nhanh gọn mà đảm bảo thơm ngon.
</p>
<p>
Nếu nấu các món trên bằng nồi cơm điện thường thì sẽ dẫn đến tình trang nồi dễ bị hư hỏng, do vậy lựa chọn nồi cơm điện tử là phương án tốt nhất.
</p>
<h5>4. Chất liệu cao cấp, an toàn</h5>
<p>
+ Vỏ nồi chất liệu bền bỉ cách điện tốt, hạn chế hư hại hay móp méo do va đập.
</p>
<p>
+ Nắp nồi kín giữ nhiệt tốt cho cơm chín nhanh, ấm lâu.
</p>
+ Lòng nồi có độ dày chuẩn với lớp chống dính an toàn cho cơm chín nhanh, ngon mà không bị dính, an toàn sức khỏe.
<p>
+ Van thoát hơi thông minh duy trì lượng hơi nước ổn định tối ưu trong quá trình nấu cơm, cho cơm chín đều tơi xốp và bảo toàn vitamin trong gạo.
</p>
<p>
+ Nắp trong thiết kế tổ ong hạn chế đọng hơi nước cho cơm khô mặt, lâu hư.
</p>
<h5>5. Ứng dụng các công nghệ nấu tiên tiến giúp cơm ngon hơn</h5>
<p>
Công nghệ nấu 3D sử dụng 3 mâm nhiệt: mâm nhiệt đáy nồi, mâm nhiệt nắp nồi và dây điện quanh thân nồi cho nhiệt lượng truyền từ phía dưới, phía trên và xung quanh nồi giúp hạt gạo chín từ từ, đều từ bên trong, nhờ vậy hạt cơm ngon hơn, tránh hiện tượng cơm bị nhão mặt.
</p>
<p>
Chính vì thế lựa chọn nồi cơm điện tử là người dùng đã đảm bảo được những bữa cơm ngon cho gia đình.
</p>
<p>
<b>Nguồn: <a href="https://giadungsato.com/5-ly-do-ban-nen-mua-noi-com-dien-tu-su-dung-trong-gia-dinh">https://giadungsato.com/5-ly-do-ban-nen-mua-noi-com-dien-tu-su-dung-trong-gia-dinh</a></b>
</p>
'
) ,

( 2 , N'Vì sao nên dùng bếp điện thay thế bếp gas?' , '2.jpg' ,
N'
<p>
Ngày nay, nhiều gia đình có xu hướng sử dụng bếp điện thay thế cho bếp gas. Bếp hồng ngoại và bếp từ có nhiều ưu điểm vượt trội so với bếp gas nên được nhiều người ưa chuộng. Vì sao nên dùng bếp điện thay thế cho bếp gas?
</p>
<h5>Hiệu suất cao</h5>
<p>
Bếp từ và bếp hồng ngoại có hiệu suất năng lượng lần lượt là 95% và 65%, đều cao hơn mức 40% của bếp gas. (Theo Wikipedia)
</p>
<h4>Đun nấu nhanh chóng</h4>
<p>
Hiệu suất năng lượng cao hơn đồng nghĩa với việc bếp đun nấu hiệu quả hơn và tiết kiệm thời gian nấu nướng.
</p>
<h5>Giảm chi phí</h5>
<p>
Tính toán một cách tương đối, giá tiền một bình gas 12 kg là 491 nghìn đồng, đun sôi được 1920 kg nước. Nếu sử dụng bếp điện thì cần 160 kW điện, tương đương 320 nghìn đồng. Nhìn chung, khi sử dụng bếp điện bạn sẽ tiết kiệm được một khoản kha khá.
</p>
<h5>Độ an toàn cao</h5>
<p>
Nhiều người khi sử dụng bếp gas rất lo lắng những sự cố cháy nổ, rò rỉ gas. Khi dùng bếp điện, bạn hoàn toàn có thể gạt bỏ mối lo này.
</p>
<p>
Bếp điện không lửa, không khói, đảm bảo an toàn hơn cho người dùng, đặc biệt là trẻ nhỏ. Đặc biệt là bề mặt bếp từ vẫn mát khi đun nấu, người dùng có thể an tâm sử dụng.
</p>
<h5>Đa năng</h5>
<p>
Bếp điện trang bị tính năng hẹn giờ, thực đơn tự động tiện lợi, giảm bớt công sức khi vào bếp của các bà nội trợ. Bảng điều khiển và màn hình hiển thị giúp người dùng dễ dàng điều chỉnh nhiệt độ, công suất chính xác.
</p>
<h5>Mẫu mã đẹp, thiết kế phẳng, dễ vệ sinh</h5>
<p>
Các loại bếp điện đều có kích thước nhỏ gọn, mỏng, dễ lắp đặt, phù hợp với mọi không gian nhà bếp. Bếp điện có thiết kế đẹp, sang trọng, tô điểm thêm cho gian bếp gia đình. Bề mặt bếp làm bằng kính, phẳng, bóng loáng, dễ dàng chùi rửa sau khi dùng xong.
</p>
<p>
Trong khi bếp gas do thiết kế kiềng bếp, đầu đốt và các bộ phận khác không liền khối như bếp điện, rất khó vệ sinh, có thể lưu lại dầu mỡ hay thức ăn thừa ở các khe kẽ nên nếu để lâu sẽ làm bếp bị gỉ sét.
</p>
<p>
<b>Nguồn: <a href="https://www.dienmayxanh.com/kinh-nghiem-hay/vi-sao-nen-dung-bep-dien-thay-the-bep-gas-803026">https://www.dienmayxanh.com/kinh-nghiem-hay/vi-sao-nen-dung-bep-dien-thay-the-bep-gas-803026</a></b>
</p>
'
) ,

( 3 , N'Có nên mua máy xay sinh tố đa năng?' , '3.jpg' ,
N'
<p>
Một chiếc máy xay sinh tố đa năng có nhiều công dụng phục vụ nhu cầu ăn uống của các thành viên trong gia đình, ví dụ xay hạt, xay sinh tố, ép nước trái cây. Hiện nay trên thị trường có đa dạng các loại máy xay sinh tố đa năng khác nhau với nhiều kiểu dáng mẫu mã dễ dàng cho người tiêu dùng lựa chọn. Vậy có nên mua máy xay sinh tố đa năng hay không? Hãy cùng tham khảo bài viết để có câu trả lời.
</p>
<h5>1. Máy xay sinh tố đa năng là gì?</h5>
<p>
Máy xay sinh tố đa năng là loại máy xay tích hợp nhiều tính năng, vừa có khả năng xay, ép nước trái cây vừa có thể xay thịt, trộn gia vị, đánh trứng…
</p>
<p>
Một máy xay sinh tố đa năng bao gồm các phụ kiện kèm theo như cối xay, các loại lưỡi dao. Chính vì thế, thiết bị đa năng này có khả năng thay thế cho nhiều các thiết bị gia dụng khác như các loại máy ép, máy vắt thông thường.
</p>
<h5>2. Máy xay sinh tố đa năng có những ưu điểm gì nổi trội?</h5>
<p>
- <b>Xay sinh tố</b>: Đa số các loại máy xay sinh tố đa năng hiện nay đều được trang bị lưới lọc, giúp bạn dễ dàng có một ly sinh tố sánh mịn mà không mất thời gian và dụng cụ để lọc bỏ cặn.
</p>
<p>
- <b>Ép nước trái cây</b>: máy xay sinh tố đa năng có thiết kế ống tiếp nguyên liệu có đường kính lớn, hỗ trợ người dùng ép trực tiếp trái cây mà không cần cắt nhỏ thành từng miếng, giúp người dùng có ly nước ép nhiều vitamin và khoáng chất, tốt cho sức khỏe và sắc đẹp.
</p>
<p>
- <b>Xay thịt</b>: Ngoài khả năng chế biến các loại rau củ, máy xay sinh tố có khả năng xay nhuyễn thịt để chế biến các món cháo dinh dưỡng, nấu canh, chế biến nhiều món ăn khác nhau cho gia đình. Tùy thuộc vào khẩu vị ăn của các thành viên, bạn có thể điều chỉnh các mức xay khác nhau để cho ra một món ăn như ý.
</p>
<p>
- <b>Xay gia vị, ngũ cốc</b>: Cối xay của máy xay sinh tố đa năng tích hợp tiện ích xay các thực phẩm khô, các loại hạt, gia vị như hạt tiêu, hạt cà phê, hạt đậu,...nhờ đó người tiêu dùng dễ dàng có những loại gia vị đơn giản tại nhà mà không phải bỏ ra nhiều thời gian và công sức.
</p>
<p>
- <b>Công suất mạnh mẽ</b>: công suất hoạt động thông thường của các loại máy xay sinh tố đa năng thường từ 220 W đến hơn 500 W, hỗ trợ máy có khả năng xay mịn tất cả các loại thực phẩm và hoạt động với cường độ cao, liên tục.
</p>
<p>
- <b>Hệ thống ngắt điện tự động</b>: Mỗi một máy xay sinh tố đa năng đều được trang bị khóa an toàn, chỉ cho phép máy hoạt động khi máy được lắp đúng khớp. Đồng thời khi máy hoạt động quá lâu, hoặc hoạt động với lượng thực phẩm quá tải, để bảo vệ động cơ điện, máy sẽ tự động ngắt nhằm đảm bảo an toàn và gia tăng tuổi thọ cho sản phẩm.
</p>
<p>
Như vậy với một chiếc máy xay sinh tố đa năng có thể đáp ứng nhiều nhu cầu của các thành viên trong gia đình. Khi có nhu cầu xay loại thực phẩm nào, người dùng chỉ cần lắp cối tương ứng lên thân máy và nhấn nút. Rất đơn giản! Đó là lý do vì sao dòng sản phẩm này được nhiều người dùng ưa chuộng.
</p>
<p>
<b>Nguồn: <a href="https://dienmaycholon.vn/kinh-nghiem-mua-sam/co-nen-mua-may-xay-sinh-to-da-nang">https://dienmaycholon.vn/kinh-nghiem-mua-sam/co-nen-mua-may-xay-sinh-to-da-nang</a></b>
</p>
'
)
go

SET IDENTITY_INSERT news OFF 
go