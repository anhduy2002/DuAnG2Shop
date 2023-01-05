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
	id						tinyint			primary key,
	[name]					nvarchar(20)	not null unique
)
go

create table users
(
	id						bigint			primary key identity,
	username				varchar(20)		not null unique,
	fullname				nvarchar(50)	not null,
	hashPassword			varchar(255)	not null,
	email					varchar(100)	not null unique,
	phone					varchar(11)		not null unique,
	createdDate				datetime		not null default getdate(),
	isEnabled				bit				not null default 0,
	authProvider			varchar(15)		null,
	resetPasswordToken		varchar(30)		null,
	verificationCode		varchar(64)		null,
	isDeleted				bit				not null default 0,
	roleId					tinyint			foreign key references roles( id ),
)
go

create table categories
(
	id						tinyint			primary key identity,
	[name]					nvarchar(50)	not null,
	slug					varchar(255)	not null unique,
	isDeleted				bit				not null default 0
)
go

create table brands
(
	id						tinyint			primary key identity,
	[name]					nvarchar(50)	not null,
	slug					varchar(255)	not null unique,
	isDeleted				bit				not null default 0
)

create table products
(
	id						bigint			primary key identity,
	[name]					nvarchar(255)	not null,
	quantity				int				not null check( quantity >= 0 ),
	discount				int				not null check( discount >= 0 and discount <= 100 ),
	price					int				not null,
	imageName				varchar(255)	null default 'main.jpg',
	[description]			ntext			null,
	slug					varchar(255)	not null unique,
	isDeleted				bit				not null default 0,
	categoryId				tinyint			foreign key references categories( id ),
	brandId					tinyint			foreign key references brands( id ),
)
go

Create table product_images
(
	id						bigint			primary key identity,
	[name]					varchar(255)	not null,
	productId				bigint			foreign key references products( id ),
)
go

create table reviews
(
	id						bigint			primary key identity,
	score					tinyint			not null default 0 check( score >= 0 and score <= 5 ),
	[description]			ntext			null,
	imageName				varchar(255)	null,
	createdDate				datetime		not null default getdate(),
	customerId				bigint			foreign key references users( id ),
	productId				bigint			foreign key references products( id ),
)
go

create table favorites
(
	id						bigint			primary key identity,
	isCanceled				bit				not null default 0 ,
	createdDate				datetime		not null default getdate(),
	customerId				bigint			foreign key references users( id ),
	productId				bigint			foreign key references products( id )
)
go


create table orders
(
	id						bigint			primary key identity,
	[address]				nvarchar(255)	not null,
	phone					varchar(11)		not null,
	createdDate				datetime		not null default getdate(),
	orderStatus				int				not null default 0,
	shippingFee				int				not null default 0 check( shippingFee >= 0 ),
	customerId				bigint			foreign key references users( id ) ,
	confirmingStaffId		bigint			foreign key references users( id )
)
go

create table order_details
(
	id						bigint			primary key identity,
	price					int				not null check( price > 0 ),
	quantity				int				not null check( quantity > 0 ),
	orderId					bigint			foreign key references orders( id ),
	productId				bigint			foreign key references products( id ),
)
go

SET IDENTITY_INSERT categories ON
insert into categories ( id , [name] , slug ) values
( 1	, N'Nồi cơm điện'				, 'noi-com-dien'		) ,
( 2	, N'Bếp các loại'				, 'bep-cac-loai'		) ,
( 3	, N'Lò vi sóng - lò nướng'		, 'lo-vi-song-lo-nuong'	) ,
( 4	, N'Máy xay sinh tố'			, 'may-xay-sinh-to'		) ,
( 5	, N'Lọc không khí'				, 'loc-khong-khi'		) ,
( 6 , N'Hút bụi'					, 'hut-bui'				) ,
( 7	, N'Máy lọc nước'				, 'may-loc-nuoc'		)
go

SET IDENTITY_INSERT categories OFF 
go

SET IDENTITY_INSERT brands ON
insert into brands ( id , [name] , slug ) values
( 1		, N'Cuckoo' 	, 'cuckoo' 		) ,
( 2		, N'Kangaroo' 	, 'kangaroo' 	) ,
( 3		, N'LG' 		, 'lg' 			) ,
( 4		, N'Panasonic' 	, 'panasonic' 	) ,
( 5		, N'Samsung' 	, 'samsung' 	) ,
( 6		, N'Sanaky' 	, 'sanaky' 		) ,
( 7		, N'Sharp' 		, 'sharp' 		) ,
( 8		, N'Sunhouse' 	, 'sunhouse' 	) ,
( 9		, N'Toshiba' 	, 'toshiba' 	) ,
( 10 	, N'Khác' 		, 'khac' 		)
SET IDENTITY_INSERT brands OFF
go

SET IDENTITY_INSERT products ON
insert into products ( id , [name] , quantity , discount , price , [description] , slug , categoryId , brandId ) values

-- Nồi cơm điện
-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-nap-gai-kangaroo-kg835-18l
( 
	1 , 
	N'Nồi cơm điện nắp gài Kangaroo 1.8 lít S1' ,
	100 , 40 , 1380000 ,
	N'
	Nồi cơm điện Kangaroo kiểu dáng mềm mại, hiện đại, trẻ trung bắt mắt mới 2 màu đỏ và trắng, tạo điểm nhấn cho gian bếp gia đình.
	Dung tích nồi 1.8 lít phục vụ tốt cho các gia đình 4 – 6 người ăn.
	Nồi cơm nắp gài dễ sử dụng với hệ nút nhấn điện tử có màn hình hiển thị, đa chức năng nấu tùy chọn theo nhu cầu.
	Nồi có thể nấu cơm, nấu súp, làm bánh, hầm, nấu cháo, nấu thịt gà và giữ ấm, rất tiện lợi cho các bữa ăn gia đình.
	Nấu cơm chín nhanh với thời gian mặc định 30 phút và tối thiểu 20 phút là bạn đã có bữa cơm ngon cùng với gia đình của mình.
	Lòng nồi 2 lớp phủ hợp kim nhôm tráng men chống dính, dày 2 mm, bền bỉ, chống dính cháy, cho cơm chín ngon, dễ lau chùi sau khi dùng.
	Mâm nhiệt đáy nồi bằng chất liệu nhôm nguyên chất gia nhiệt nhanh, nấu cơm chín mau, tiết kiệm thời gian và điện năng tiêu thụ.
	Công nghệ ủ ấm 3D giúp nồi giữ ấm cơm lâu, cơm ngon ấm nóng sẵn sàng phục vụ gia đình trong nhiều giờ.
	Kèm thêm xửng hấp cho người dùng chế biến các món hấp đơn giản như rau củ, nấu xôi, làm bánh, ...
	Nồi cơm điện nắp gài Kangaroo KG835 1.8L sản phẩm đẹp, dễ dùng, dùng bền, phục vụ tốt cho từng bữa ăn gia đình.
	',
	'noi-com-dien-nap-gai-kangaroo-1.8-lit-s1' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/kangaroo-kg378h-18-lit
( 
	2 , 
	N'Nồi cơm điện nắp gài Kangaroo 1.8 lít S2' ,
	100 , 7 , 840000 ,
	N'
	Nồi cơm nắp gài Kangaroo kiểu dáng đơn giản, họa tiết hoa Hàn Quốc trên thân nồi đẹp mắt.
	Thiết kế nổi bật trên nền đỏ - trắng chủ đạo cho tổng thể thiết kế hiện đại, có tính thẩm mỹ cao. Dung tích 1.8 lít đáp ứng nhu cầu nấu cơm cho gia đình có từ 4 - 6 thành viên.
	Cơm chín nhanh chóng khoảng 20 - 30 phút với công suất mạnh mẽ 700W, công nghệ nấu 1D.
	Trong nồi có trang bị 1 mâm nhiệt phẳng truyền nhiệt rộng, cho hiệu suất nấu cao.
	Điều khiển nút gạt tùy chỉnh chức năng nấu - giữ ấm dễ sử dụng.
	Chế độ giữ ấm 3D của nồi cơm điện giúp cơm chín đều, thơm ngon hơn.
	Kiểm soát hơi nước, cho cơm bổ dưỡng, hạn chế nhão với van thoát hơi, khay hứng nước thừa và nắp trong dạng tổ ong.
	Có xửng hấp đi kèm nồi cơm điện Kangaroo cho bạn hấp bánh bao, rau củ,... thuận tiện.
	Lưu ý:
	- Không vo gạo trực tiếp trong lòng nồi để hạn chế làm trầy lớp chống dính.
	- Khi đang nấu cơm, không nên dùng khăn hoặc vật dụng để chặn van thoát hơi.
	- Chùi rửa nồi sạch sẽ sau mỗi lần nấu để tránh ám mùi cho lần nấu tiếp theo.
	Nồi cơm nắp gài Kangaroo KG378H 1.8 lít, sản phẩm của thương hiệu nổi tiếng Kangaroo - Việt Nam, sản xuất tại Trung Quốc, kết cấu gọn đẹp, màu sắc nổi bật, nấu cơm chín ngon, hứa hẹn sẽ là trợ thủ phòng bếp đắc lực cho bạn.
	',
	'noi-com-dien-nap-gai-kangaroo-1.8-lit-s2' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-sunhouse-shd8607w
( 
	3 , 
	N'Nồi cơm điện nắp gài Sunhouse 1.8 lít S3' ,
	100 , 18 , 950000 ,
	N'
	Nồi cơm điện Sunhouse có màu trắng hồng nhẹ nhàng, xinh xắn, phù hợp với thị hiếu của nữ giới.
	Thân nồi cơm điện dày, kiểu nồi cơm nắp gài cho nồi giữ nhiệt tốt, cơm nóng ngon lâu.
	Nấu đủ cơm cho gia đình có 4 - 6 thành viên với dung tích 1.8 lít.
	Nút gạt thiết kế ở mặt trước thân nồi cho bạn chỉnh chức năng nấu và giữ ấm dễ dàng, linh hoạt.
	Lòng nồi 2 lớp dày 1.207 mm làm bằng hợp kim nhôm phủ lớp chống dính Whitford - USA, an toàn cho sức khỏe, nấu cơm chín ngon, tơi, hấp dẫn, làm sạch, vệ sinh đơn giản.
	Nấu cơm chín nhanh với công nghệ nấu 1D, công suất 700W, tiết kiệm điện năng của gia đình.
	Nồi có chế độ ủ ấm 3D cho khả năng giữ ấm cơm lâu đến 24 tiếng.
	Chỉ tiêu tốn khoảng 20 - 25 phút bạn đã có cơm nóng, thơm ngon để thưởng thức cùng gia đình.
	Hấp thức ăn đơn giản, thuận tiện với xửng hấp được tặng kèm nồi.
	Nồi cơm nắp gài Sunhouse 1.8 lít SHD8607W thiết kế đẹp, dùng nấu cơm nhanh, giá cả phải chăng, xứng đáng có mặt trong mọi gia đình.
	' ,
	'noi-com-dien-nap-gai-sunhouse-1.8-lit-s3' ,
	1 , 8
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-toshiba-rc-18jh2pv-b-18l
( 
	4 , 
	N'Nồi cơm điện nắp gài Toshiba 1.8 lít S4' ,
	100 , 5 , 820000 , 
	N'
	Nồi cơm nắp gài Toshiba 1.8 lít RC-18JH2PV(B) thiết kế hiện đại, màu sắc trẻ trung phù hợp mọi căn bếp.
	Dung tích nồi cơm điện 1.8 lít đáp ứng tốt nhu cầu nấu cơm cho gia đình có từ 4 - 6 người.
	Nút gạt thiết kế ở mặt trước thân nồi cho bạn chỉnh chức năng nấu và giữ ấm dễ dàng, linh hoạt.
	Giữ ấm tự động lên đến 6 tiếng.
	Công nghệ 1D (toả nhiệt từ 1 hướng) với công suất lớn 650 W giúp truyền nhiệt nhanh, cơm chín mau, ít tốn điện.
	Nấu cơm nhanh chín chỉ sau 25 – 30 phút, tiết kiệm điện hiệu quả.
	Lòng nồi cơm điện Toshiba 2 lớp bằng hợp kim nhôm phủ lớp chống dính, dày 1 mm, an toàn với sức khoẻ và vệ sinh đơn giản.
	Đảm bảo cơm chín tơi, ngon, không dính vào thành, đáy nồi, tiện chùi rửa.
	Nắp trong của nồi thiết kế dạng tổ ong giúp giữ lại hơi nước, không để nó rơi ngược vào cơm gây nhão, thiu.
	Hấp thức ăn đơn giản, thuận tiện với xửng hấp được tặng kèm nồi.
	Nồi cơm nắp gài Toshiba 1.8 lít RC-18JH2PV(B) thiết kế trang nhã, tiện dụng, nấu cơm ngon, là lựa chọn tuyệt hảo cho gia đình Việt.
	',
	'noi-com-dien-nap-gai-toshiba-18-lit-s4' ,
	1 , 9
) ,

-- https://www.dienmayxanh.com/noi-com-dien/sharp-ksh-d15v
( 
	5 , 
	N'Nồi cơm điện Sharp 1.5 lít S5' ,
	100 , 5 , 700000 , 
	N'
	Nồi cơm điện Sharp 1.5 lít KSH-D15V có thân nồi màu trắng đỏ nổi bật, nắp bằng thép không gỉ.
	Dung tích nồi cơm nắp rời 1.5 lít, có thể dùng nấu cơm cho gia đình từ 2 - 4 người.
	Chế độ nấu và giữ ấm dễ dàng tùy chỉnh với nút gạt, thời gian giữ ấm của nồi lâu đến 5 giờ.
	Nồi sau khi nấu cơm xong sẽ tự động chuyển sang chế độ giữ ấm và giữ cho cơm nóng ngon trong thời gian dài, đảm bảo bạn có cơm nóng hổi thưởng thức mọi lúc.
	Công nghệ nấu 1D cùng công suất 530W giúp nấu cơm chín nhanh, ít hao điện.
	Lòng nồi 1 lớp dày 1 mm bằng nhôm dày bền, an toàn cho sức khỏe, dễ vệ sinh.
	Tay cầm và chân đế bọc nhựa Phenolic cách nhiệt tốt, không sợ nóng, bỏng tay khi di chuyển.
	Dây điện tháo rời, thuận tiện cho việc di chuyển và cất giữ nồi.
	Nồi cơm nắp rời Sharp 1.5 lít KSH-D15V sử dụng bền lâu, an toàn, phù hợp với nhu cầu nấu cơm cơ bản của mọi gia đình.
	',
	'noi-com-dien-sharp-15-lit-s5' ,
	1 , 7
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-roi-sunhouse-shd8135
( 
	6 , 
	N'Nồi cơm điện Sunhouse 2.2 lít S6' ,
	100 , 5 , 890000 , 
	N'
	Nồi cơm điện Sunhouse thiết kế đẹp mắt, màu sắc hài hoà, ấm cúng.
	Dung tích nồi 2.2 lít đáp ứng đủ nhu cầu nấu cơm cho cả gia đình từ 6 thành viên trở lên.
	Bảng điều khiển nút gạt 1 thao tác, đơn giản dễ sử dụng.
	Lòng nồi cơm điện dày 0,8 mm làm bằng hợp kim nhôm dày bền, chống móp méo tốt, giữ nhiệt hiệu quả, nấu an toàn, cơm chín ngon.
	Chỉ tiêu tốn khoảng 20 - 25 phút bạn đã có cơm nóng hổi, thơm ngon để thưởng thức cùng gia đình.
	Nồi cơm điện nấu cơm nhanh với công nghệ 1D với công suất 900W, tiết kiệm thời gian và điện năng, giữ ấm được 4 tiếng.
	Nồi với xửng hấp lớn tiện lợi, giúp bạn hấp bánh bao, rau củ dễ dàng.
	Lưu ý khi sử dụng nồi cơm điện:
	- Không vo gạo trong nồi, nên vo gạo bằng rổ sau đó cho vào lòng nồi.
	- Lau khô lòng nồi trước khi nấu. 
	- Hạn chế cắm dây điện của nồi cơm chung ổ cắm với các thiết bị khác có công suất cao. 
	- Không bít lỗ thoát hơi.
	- Không chà nồi bằng miếng kim loại.
	Nồi cơm nắp rời Sunhouse 2.2 lít SHD8135 thương hiệu uy tín, chất lượng, nấu cơm ngon được nhiều người tin dùng. 
	',
	'noi-com-dien-sunhouse-22-lit-s6' ,
	1 , 8
) ,

-- https://www.dienmayxanh.com/noi-com-dien/cuckoo-crp-pk1000s-18-lit
( 
	7 , 
	N'Nồi cơm điện tử áp suất Cuckoo 1.8 lít S7' ,
	100 , 10 , 4369000 ,
	N'
	Nồi cơm điện tử áp suất Cuckoo CRP-PK1000S 1.8 lít với lớp vỏ màu trắng trang nhã, thiết kế hiện đại tạo sự độc đáo trong không gian sống.
	Nồi cơm điện tử áp suất Cuckoo mang đặc điểm của cả 2 dạng nồi điện tử và áp suất, giúp giữ kín lượng hơi nước, hạn chế hơi nước thoát ra trong quá trình nấu, khiến áp suất trong nồi tăng cao, làm thức ăn chín mềm hơn.
	Sử dụng hệ thống cung cấp nhiệt ở đáy, xung quanh thân nồi và trên nắp nồi nên nồi cơm điện tử áp suất cho cơm chín đều, thơm ngon và bảo toàn dinh dưỡng hơn.
	Nồi cơm Cuckoo với màu trắng ngà trang nhã, quý phái, giúp tăng tính thẩm mỹ cho không gian bếp.
	Dung tích 1.8 lít dùng nấu cơm phù hợp cho gia đình 4 – 6 thành viên.
	Nấu được 8 - 10 cốc gạo đi kèm nồi.
	Nồi cơm điện Cuckoo trang bị lòng nồi phủ men X-Wall Marble cao cấp độc quyền của Cuckoo.
	Độ dày lòng nồi 3.183 mm, bền bỉ, nấu cơm an toàn, không dính cháy, chống trầy xước, dễ dàng vệ sinh. Có tay cầm 2 bên thành nồi tiện lợi, tránh bỏng nóng khi sử dụng.
	Nồi cơm điện tử áp suất sử dụng thuận tiện qua bảng điều khiển nút nhấn điện tử dễ thao tác.
	Nồi có chức năng hẹn giờ đến 12 tiếng 50 phút, hỗ trợ bạn nấu nướng linh hoạt thời gian.
	Sở hữu 12 chương trình cài sẵn tiện lợi
	Gồm chức năng: cháo đặc, cơm cháy, gạo trộn, giữ ấm, gạo lứt, gạo lứt nảy mầm Gaba, gạo nếp, nấu cơm, nấu nhanh, nấu nhiệt độ cao, nấu đa năng, tự động làm sạch hỗ trợ tích cực cho người nội trợ, đơn giản hóa việc chuẩn bị những bữa ăn ngon giàu dinh dưỡng cho gia đình.
	Lưu ý: Hãng khuyến cáo nên điều chỉnh chức năng giữ ấm tối đa 24 tiếng (và còn tùy vào khí hậu, loại gạo,...) để đảm bảo vẫn giữ được chất lượng cơm nấu ra.
	Nồi nấu cơm chín đều thơm ngon, giữ lại tối đa dưỡng chất trong gạo nhờ công nghệ nấu 3D.
	Van thoát hơi thông minh kiểm soát lượng hơi nước thoát ra, giữ lại nhiều dưỡng chất và vitamin trong gạo.
	Khay hứng nước thừa giữ vệ sinh, tránh văng nước ra ngoài khi sử dụng.
	Dây điện của nồi dài 126 cm giúp người dùng có thể sử dụng nồi ở nơi xa nguồn điện.
	Sử dụng nồi cơm điện bền tốt
	- Kiểm tra ổ cắm, dây điện có bị hở, rò rỉ điện khi kết nối với nồi, tránh hiện tượng chập điện.
	- Sử dụng muỗng lấy cơm bằng nhựa, silicone hoặc gỗ để tránh làm trầy xước mặt chống dính.
	- Không vệ sinh khi lòng nồi còn nóng.
	- Làm sạch lòng nồi, vỏ nồi, nắp trong, khay hứng nước để nồi cơm đảm bảo sạch sẽ, vệ sinh, an toàn khi nấu, tránh gây ám mùi.
	Nồi cơm điện tử áp suất Cuckoo CRP-PK1000S 1.8 lít nhập khẩu trực tiếp từ Hàn Quốc, hiện đại, đa chức năng tiện dụng, nấu ngon, an toàn, lựa chọn hữu ích cho gian bếp gia đình.
	',
	'noi-com-dien-tu-ap-suat-cuckoo-18-lit-s7' ,
	1 , 1
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-tu-ap-suat-mishio-1-lit-mk-303
( 
	8 , 
	N'Nồi cơm điện tử áp suất Mishio 1 lít S8' ,
	100 , 10 , 1990000 , 
	N'
	Nồi cơm điện tử áp suất Mishio 1 lít MK-303 là sản phẩm nồi cơm kết hợp nồi nấu áp suất, hẹn giờ và giữ ấm đến 24 tiếng, đa dạng chương trình cài đặt sẵn,... hỗ trợ bạn chế biến nhiều món ăn bổ dưỡng cho gia đình.
	Công nghệ nấu, công suất - Dung tích
	Công suất 600W kết hợp công nghệ nấu 1D giúp nồi nấu thức ăn chín nhanh, tiết kiệm điện năng.
	Dung tích 1 lít nhỏ gọn, nấu được 5 - 8 cốc gạo kèm nồi, đáp ứng tốt khẩu phần ăn cho 2 - 4 người.
	Bảng điều khiển - Chương trình cài đặt sẵn
	- Bảng điều khiển cảm ứng hiện đại, có màn hình hiển thị, dễ quan sát và điều chỉnh các chức năng.
	- 11 chương trình cài đặt sẵn giúp bạn nấu đa dạng món ngon: cháo, giữ ấm, hâm nóng, hạt ngũ cốc, hầm nhanh, nấu bò, nấu cơm, nấu gà, nấu đậu/gân, súp, đồ ăn trẻ em.
	Thiết kế của sản phẩm
	- Mẫu nồi cơm điện Mishio này được thiết kế nhỏ gọn, màu đen trung tính và hiện đại, dễ di chuyển và đặt gọn trên bàn ăn. 
	- Vỏ ngoài bằng nhựa PP bền tốt, dễ lau chùi sau khi sử dụng.
	- Lòng nồi hợp kim nhôm phủ chống dính, gia nhiệt tốt giúp cơm chín đều, thơm ngon, chống dính cháy và tiện vệ sinh.
	Tiện ích - Phụ kiện
	- Hẹn giờ và giữ ấm cơm đến 24 tiếng, giúp gia đình luôn có cơm nóng để thưởng thức khi cần.
	- Trang bị tính năng tự động xả áp khi áp suất trong nồi đạt giới hạn và chỉ có thể mở nắp khi áp suất trong nồi đã hết, để bạn nấu nướng an toàn, tiện lợi hơn.
	- Phụ kiện đi kèm nồi cơm điện: cốc đong, muỗng cơm.
	Nồi cơm điện tử áp suất Mishio 1 lít MK-303​ sở hữu tính năng nấu áp suất, nhiều chương trình cài sẵn tiện lợi, dễ sử dụng, thích hợp cho những bà nội trợ bận rộn, mang đến cho gia đình những món ăn nóng hổi, giàu dinh dưỡng.
	',
	'noi-com-dien-tu-ap-suat-mishio-18-lit-s8' ,
	1 , 10
) ,

-- https://www.dienmayxanh.com/noi-com-dien/cao-tan-kangaroo-kg599n
( 
	9 , 
	N'Nồi cơm điện cao tần Kangaroo 1.8 lít S9' ,
	100 , 19 , 3280000 , 
	N'
	Nồi cơm điện cao tần Kangaroo KG599N có vỏ ngoài bằng thép không gỉ sáng bóng, kết cấu bền chắc.
	Sử dụng bền lâu, tăng tính thẩm mỹ cho mọi gian bếp.
	Dung tích 1.8 lít, nồi cơm điện đáp ứng nhu cầu nấu cơm trong gia đình có từ 4 – 6 thành viên.
	Bảng điều khiển điện tử hướng dẫn tiếng Việt, màn hình hiển thị rõ ràng giúp bạn tùy chỉnh các chức năng, chế độ nấu linh hoạt, chính xác.
	Có các chế độ nấu tự động đa dạng gồm nấu cơm tiêu chuẩn, nấu chậm, nấu nhanh, cơm niêu, nấu súp, nấu cháo nguyên hạt, cháo nhừ, làm bánh, hấp, hâm nóng, giữ ấm,... giúp bạn nấu ăn thuận tiện, đa dạng bữa cơm cho gia đình.
	Ngoài ra, bạn có thể chọn chế độ nấu cho từng loại gạo giúp bạn nấu cơm ngon, bổ dưỡng hơn.
	Nồi còn có chức năng hẹn giờ nấu đến 24 tiếng, giúp bạn chủ động thời gian nấu nướng.
	Công suất 1200 W, sử dụng công nghệ cao tần giúp cơm được nấu chín đều, thơm ngon, tơi xốp hơn.
	Lòng nồi bằng hợp kim nhôm có 7 lớp, độ dày 2 mm siêu bền, an toàn khi nấu.
	Cơm chín tơi, ngon, không bám dính vào thành và đáy nồi, không có cơm cháy, dễ làm sạch.
	Ngoài ra, lòng nồi dày giúp giữ ấm cơm lâu hơn mà ít tốn điện hơn.
	Nắp trong của nồi dạng tổ ong ngăn nước rơi ngược vào cơm, chống nhão, thiu hiệu quả.
	Hơn thế, phía dưới nắp nồi cơm điện cao tần có điện trở sưởi giúp giữ ấm cơm đến 24 tiếng mà cơm không bị hư, thiu như những nồi cơm thông thường khác; khi nấu cơm chín, sẽ có một ít lượng hơi nước chảy dọc ra xung quanh vành ngoài lòng nồi.
	Quai xách cho phép bạn di chuyển nồi đến mọi địa điểm nhanh gọn, an toàn.
	Nồi cơm điện cao tần Kangaroo KG599N thiết kế đẹp, nhiều tính năng, nấu ăn ngon, hiệu quả, xứng đáng có mặt trong gia đình Việt.
	',
	'noi-com-dien-cao-tan-kangaroo-18-lit-s9' ,
	1 , 2
) ,

-- https://www.dienmayxanh.com/noi-com-dien/dien-tu-toshiba-rc-18rh-cg-vn
( 
	10 , 
	N'Nồi cơm điện cao tần Toshiba 1.8 lít S10' ,
	100 , 6 , 5990000 , 
	N'
	Nồi cơm điện cao tần Toshiba RC-18RH(CG)VN thiết kế sang trọng, thân nồi dày, giữ nhiệt lâu.
	Dung tích 1.8 lít nồi đáp ứng nhu cầu sử dụng của gia đình có từ 4 – 6 thành viên.
	Bảng điều khiển điện tử với nhiều nút nhấn rõ ràng cho phép bạn tùy chỉnh các chức năng chính xác, dễ dàng.
	Chức năng nấu tự động đa dạng, hẹn giờ tiện dụng
	Bạn có thể nấu cơm trắng thường, cơm mềm, cơm khô, nấu cơm trộn, gạo lứt, làm bánh, hấp, nấu cháo, luộc trứng,… thêm chức năng giữ ấm 24 tiếng, hâm nóng giúp bạn chuẩn bị bữa cơm gia đình đa dạng chỉ với 1 nồi cơm điện tử cao tần.
	Chức năng hẹn giờ nấu xong cho phép bạn tùy chọn thời gian nấu phù hợp với từng món ăn tiện lợi, giúp bạn chế biến món ăn ngon, đúng thời gian hơn.
	Lưu ý: Hãng khuyến cáo chức năng hẹn giờ nên cài đặt 12 - 24 tiếng (và còn tùy thuộc vào khí hậu, loại gạo,...) để giữ được vị ngon và dinh dưỡng trong gạo.
	Lòng nồi 3 lớp dày 1.7 mm bằng chất liệu hợp kim nhôm phủ lớp chống dính Diamond Titanium dày chắc, bền bỉ.
	An toàn khi nấu, hạt cơm chín tơi, xốp, không có cơm cháy, dễ chùi rửa bên trong lòng nồi.
	Sử dụng công nghệ nấu cao tần (IH) chỉnh chính xác nhiệt độ nấu.
	Công nghệ nấu cao tần cho phép làm nóng trực tiếp lòng nồi mà không cần thông qua mâm nhiệt, cơ chế tương tự như bếp từ, điều này giúp cho cơm ngon và bảo toàn chất dinh dưỡng nhiều hơn so với các nồi cơm sử dụng mâm nhiệt truyền thống.
	Van thoát hơi chống tràn, bảo toàn lượng dưỡng chất và vitamin có sẵn trong gạo.
	Xửng hấp thiết kế gọn đẹp giúp bạn hấp rau củ, bánh bao thuận tiện hơn.
	Nồi cơm điện cao tần Toshiba RC-18RH(CG)VN nhiều chức năng, nấu ăn ngon, đa dạng, thích hợp sử dụng trong gia đình, nhà hàng, khách sạn, ...
	',
	'noi-com-dien-cao-tan-toshiba-18-lit-s10' ,
	1 , 9
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-dien-tu-panasonic-sr-cp188nra
( 
	11 , 
	N'Nồi cơm điện tử Panasonic 1.8 lít S11' ,
	100 , 11 , 2570000 , 
	N'
	Nồi cơm điện Panasonic thiết kế đẹp mắt, màu sắc trang nhã, phù hợp với mọi không gian nhà bếp.
	Lòng nồi cơm điện 6 lớp, dày tới 4 mm, bên trong phủ lớp chống dính màu đen, bên ngoài phủ Almite và sơn đen, cho khả năng giữ ấm lâu, dễ vệ sinh.
	Nồi có dung tích 1.8 lít phù hợp nấu cơm cho 4 - 6 người ăn.
	Nồi cơm dùng công nghệ nấu 3D, giúp cơm nấu mau chín, hạn chế cơm nhão, tiết kiệm thời gian
	Nồi có khả năng giữ ấm đến 12 tiếng, hẹn giờ nấu đến 24 tiếng, hỗ trợ bạn nấu nướng linh hoạt thời gian.
	Menu nấu tự động của nồi gồm 14 chế độ, đáp ứng đủ mọi nhu cầu nấu ăn của gia đình bạn.
	Các chế độ cài đặt sẵn: nấu cơm thông thường, cơm dẻo, cơm khô, nấu nhanh/nấu hạt diêm mạch, gạo lứt, nấu ngũ cốc (hạt hỗn hợp), gạo thơm hoa nhài (gạo Jasmine), gạo nếp, nấu cháo, cơm niêu, súp/nấu chậm, làm bánh/bánh mì, hấp và giữ ấm, hỗ trợ bạn nấu nướng thuận tiện hơn.
	Nồi còn được tặng kèm xửng hấp cao cấp, giúp hấp bánh bao, hấp rau củ quả,...
	Dây điện nồi cơm có thể tháo rời dễ dàng bảo quản.
	Lưu ý khi sử dụng nồi cơm điện: 
	- Không vo gạo trong nồi.
	- Lau khô lòng nồi trước khi nấu.
	- Hạn chế cắm dây điện của nồi cơm chung ổ cắm với các thiết bị khác có công suất cao.
	- Không bít lỗ thoát hơi.
	- Không dùng miếng nhám chà nồi, đồ chà nồi có chứa kim loại.
	Nồi cơm điện tử Panasonic 1.8 lít SR-CP188NRA thương hiệu Nhật Bản, nhiều chức năng nấu tiện dụng, được nhiều người tin dùng. 
	',
	'noi-com-dien-tu-panasonic-18-lit-s11' ,
	1 , 4
) ,

-- https://www.dienmayxanh.com/noi-com-dien/tu-hommy-12-lit-bmb-30a
( 
	12 , 
	N'Nồi cơm điện tử Hommy 1.2 lít S12' ,
	100 , 27 , 1450000 , 
	N'Nồi cơm điện sở hữu 6 chức năng nấu cài đặt sẵn hỗ trợ tối đa nhu cầu nấu nướng của chị em nội trợ.',
	'noi-com-dien-tu-hommy-12-lit-s12' ,
	1 , 10
) ,

-- https://www.dienmayxanh.com/noi-com-dien/sharp-ks-18tjv
( 
	13 , 
	N'Nồi cơm điện Sharp 1.8 lít S13' ,
	100 , 11 , 680000 , 
	N'Vỏ ngoài bằng nhựa cao cấp cùng dung tích 1.8 lít phù hợp với gia đình có 4 - 6 thành viên.',
	'noi-com-dien-sharp-18-lit-s13' ,
	1 , 7
) ,

-- https://www.dienmayxanh.com/noi-com-dien/noi-com-nap-gai-sunhouse-shd8208c-cafe
( 
	14 , 
	N'Nồi cơm nắp gài Sunhouse 1 lít S14' ,
	100 , 20 , 790000 , 
	N'Nồi cơm nắp gài Sunhouse 1 lít SHD8208C kiểu dáng nhỏ gọn, thanh lịch, màu sắc tươi sáng.',
	'noi-com-nap-gai-sunhouse-1-lit-s14' ,
	1 , 8
) ,



-- Bếp các loại
-- https://www.dienmayxanh.com/bep-tu/crystal-ly-t39
( 
	15 , 
	N'Bếp từ Crystal S15' ,
	100 , 45 , 1859000 , 
	N'Bếp từ Crystal LY-T39 có công suất 2000W khi gia nhiệt nhanh, mặt bếp bằng kính Ceramic - Kanger (Trung Quốc) chịu nhiệt tốt, dễ lau chùi, nhiều tiện ích và tính năng an toàn đi kèm như hẹn giờ, chức năng Booster nấu nhanh, khóa bảng điều khiển,... ' ,
	'bep-tu-crystal-s15' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-kangaroo-kg408i
( 
	16 , 
	N'Bếp từ Kangaroo S16' ,
	100 , 31 , 1890000 , 
	N'Bếp từ Kangaroo màu đen sang trọng, hoa văn vàng đồng nổi bật, bắt mắt, thiết kế mỏng gọn đẹp mắt trong không gian sử dụng.' ,
	'bep-tu-kangaroo-s16' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/sunhouse-shd6867
( 
	17 , 
	N'Bếp từ đơn Sunhouse S17' ,
	100 , 14 , 1490000 , 
	N'Bếp từ đơn công suất 2000W giúp nấu ăn nhanh chóng, mức nhiệt tối đa lên đến 270°C.' ,
	'bep-tu-don-sunhouse-s17' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-kangaroo-kg15ic1
( 
	18 , 
	N'Bếp điện từ Kangaroo S18' ,
	100 , 26 , 1080000 , 
	N'Bếp điện từ Kangaroo KG15IC1 công suất nấu 1800W, nấu ăn nhanh tiết kiệm thời gian, hiệu quả với gia đình bận rộn yêu thích nấu nướng.' ,
	'bep-dien-tu-kangaroo-s18' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/kangaroo-kg499n
( 
	19 , 
	N'Bếp từ hồng ngoại lắp âm Kangaroo S19' ,
	100 , 26 , 4030000 , 
	N'Bếp từ hồng ngoại Kangaroo KG499N kiểu dáng hiện đại, đơn giản, thiết kế có thể lắp đặt âm sang trọng, tăng tính thẩm mỹ cho mọi gian bếp.' ,
	'bep-tu-hong-ngoai-lap-am-kangaroo-s19' ,
	2 , 2
) ,

-- https://www.dienmayxanh.com/bep-tu/toshiba-ic-20s4pv
( 
	20 , 
	N'Bếp từ Toshiba S20' ,
	100 , 6 , 1690000 , 
	N'Bếp từ Toshiba thiết kế hiện đại, màu đen lịch lãm, 4 góc bo cong mềm mại, tạo điểm nhấn cho không gian sử dụng thêm sang trọng.' ,
	'bep-tu-toshiba-s20' ,
	2 , 9
) ,


-- https://www.dienmayxanh.com/bep-tu/bep-dien-tu-hong-ngoai-sunhouse-shb9105mt
( 
	21 , 
	N'Bếp từ hồng ngoại lắp âm Sunhouse S21' ,
	100 , 30 , 4190000 , 
	N'Bếp từ hồng ngoại Sunhouse được thiết kế theo phong cách Tây Ban Nha, sang trọng, thời thượng, kết hợp bếp từ và bếp hồng ngoại, nấu ăn cực tiện dụng.' ,
	'bep-tu-hong-ngoai-lap-am-sunhouse-s21' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-tu/be-p-tu-sunhouse-shd6159
( 
	22 , 
	N'Bếp từ Sunhouse S22' ,
	100 , 5 , 1040000 , 
	N'Bếp từ đơn công suất 1800W gia nhiệt nhanh, nấu chín món ăn nhanh chóng, tiết kiệm thời gian.' ,
	'bep-tu-sunhouse-s22' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/sunhouse-shd-6005-emc
( 
	23 , 
	N'Bếp hồng ngoại Sunhouse S23' ,
	100 , 14 , 1100000 , 
	N'Mặt bếp hồng ngoại bằng kính chịu nhiệt sáng bóng, nhẵn mịn, tiện vệ sinh.' ,
	'bep-hong-ngoai-sunhouse-s23' ,
	2 , 8
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/smeg-se363etb-53664101
( 
	24 , 
	N'Bếp hồng ngoại 3 vùng nấu lắp âm Smeg S24' ,
	100 , 15 , 27290000 , 
	N'Sản phẩm bếp hồng ngoại 3 vùng nấu lắp âm Smeg SE363ETB (536.64.101) chất lượng cao thương hiệu Smeg của Ý, sản xuất tại Ý với thiết kế lắp âm sang trọng, cao cấp chuẩn Châu Âu, mang đến nét đẹp cho không gian bếp hiện đại.' ,
	'bep-hong-ngoai-3-vung-nau-lap-am-smeg-s24' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/smeg-se332eb-53564241
( 
	25 , 
	N'Bếp hồng ngoại đôi lắp âm Smeg S25' ,
	100 , 15 , 20990000 , 
	N'Bếp hồng ngoại đôi lắp âm Smeg SE332EB (535.64.241) với nhiều tính năng an toàn đảm bảo cho người dùng, có xuất xứ từ Ý đạt tiêu chuẩn Châu Âu về chất lượng, dễ dàng tuỳ chỉnh công sức với bảng điều khiển cảm ứng,... đây chắc chắn là một trợ thủ đắc lực cho các gia đình trong việc chế biến món ăn.' ,
	'bep-hong-ngoai-doi-lap-am-smeg-s25' ,
	2 , 10
) ,

-- https://www.dienmayxanh.com/bep-hong-ngoai/torino-tc0418c
( 
	26 , 
	N'Bếp hồng ngoại đôi lắp âm Torino S26' ,
	100 , 0 , 9900000 , 
	N'Bếp hồng ngoại Torino thiết kế hiện đại, tinh tế, màu đen thanh lịch.' ,
	'bep-hong-ngoai-doi-lap-am-torino-s26' ,
	2 , 10
) ,




-- Lò

-- https://www.dienmayxanh.com/lo-nuong/sharp-eo-a384rcsv-st
( 
	27 , 
	N'Lò nướng Sharp 38 lít S27' ,
	100 , 15 , 3090000 ,
	N'Lò nướng Sharp thiết kế hiện đại, vỏ và khoang lò bằng chất liệu thép không gỉ sáng bóng, dễ lau chùi, bền bỉ.' ,
	'lo-nuong-sharp-38-lit-s27' ,
	3 , 7
) ,

-- https://www.dienmayxanh.com/lo-nuong/kangaroo-kg4001-40-lit
( 
	28 , 
	N'Lò nướng Kangaroo 40 lít S28' ,
	100 , 13 , 3110000 , 
	N'Lò nướng Kangaroo dung tích 40 lít, lựa chọn phù hợp cho gia đình 4 – 6 thành viên.' ,
	'lo-nuong-kangaroo-40-lit-s28' ,
	3 , 2
) ,

-- https://www.dienmayxanh.com/lo-nuong/sanaky-vh5099s2d-50-lit
( 
	29 , 
	N'Lò nướng Sanaky 50 lít S29' ,
	100 , 6 , 2769000 , 
	N'Lò nướng thùng Sanaky dung tích 50 lít với thiết kế hình chữ nhật màu đen sang trọng, hài hòa với mọi không gian căn bếp.' ,
	'lo-nuong-sanaky-50-lot-s29' ,
	3 , 6
) ,

-- https://www.dienmayxanh.com/lo-nuong/lo-nuong-sharp-eo-b46rcsv-bk
( 
	30 , 
	N'Lò nướng Sharp 46 lít S30' ,
	100 , 0 , 2600000 , 
	N'Lò nướng Sharp mang phong cách thiết kế truyền thống nhưng khá đẹp mắt, màu sắc sang trọng, kiểu dáng gọn gàng, làm đẹp không gian lắp đặt sử dụng.' ,
	'lo-nuong-sharp-46-lit-s30' ,
	3 , 7
) ,

-- https://www.dienmayxanh.com/lo-nuong/lo-nuong-bluestone-eob-7548
( 
	31 , 
	N'Lò nướng Bluestone 38 lít S31' ,
	100 , 10 , 2599000 , 
	N'Lò nướng Bluestone thiết kế đẹp mắt, sang trọng với vỏ ngoài bằng thép sơn tĩnh điện màu đen tinh tế.' ,
	'lo-nuong-bluestone-38-lit-s31' ,
	3 , 10
) ,

-- https://www.dienmayxanh.com/lo-nuong/sunhouse-mama-shd4240-40-lit
( 
	32 , 
	N'Lò nướng Sunhouse Mama 40 lít S32' ,
	100 , 0 , 2410000 , 
	N'Lò nướng Sunhouse Mama SHD4240 40 lít có thiết kế hiện đại, sang trọng, công nghệ làm nóng điện trở nhiệt cùng 5 chế độ nướng,... hứa hẹn mang lại trải nghiệm tích cực, đáp ứng tốt nhu cầu dùng các món nướng trong gia đình.' ,
	'lo-nuong-sunhouse-mama-40-lit-s32' ,
	3 , 8
) ,



-- Máy xay sinh tố

-- https://www.dienmayxanh.com/may-xay-sinh-to/sunhouse-shd-5112-xanh
( 
	33 , 
	N'Máy xay sinh tố đa năng Sunhouse Xanh S33' ,
	100 , 17 , 510000 , 
	N'Máy xay sinh tố Sunhouse SHD 5112 Xanh màu sắc thời trang.' ,
	'may-xay-sinh-to-da-nang-sunhouse-xanh-s33' ,
	4 , 8
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/may-xay-sinh-to-toshiba-mx-60t-h#2-gia
( 
	34 , 
	N'Máy xay sinh tố đa năng Toshiba S34' ,
	100 , 6 , 890000 , 
	N'Máy xay sinh tố Toshiba chất liệu nhựa cao cấp không chứa BPA (Bisphenol A) độc hại, sử dụng an toàn sức khỏe.' ,
	'may-xay-sinh-to-da-nang-toshiba-s34' ,
	4 , 9
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/sharp-em-s155pv-wh
( 
	35 , 
	N'Máy xay sinh tố đa năng Sharp S35' ,
	100 , 10 , 949000 , 
	N'Máy xay sinh tố Sharp sử dụng xay sinh tố, xay hạt, gia vị, ngũ cốc,... với 2 cối xay bằng nhựa cao cấp nhẹ bền, kháng vỡ.' ,
	'may-xay-sinh-to-da-nang-sharp-s35' ,
	4 , 7
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/panasonic-mx-mg53c1cra
( 
	36 , 
	N'Máy xay sinh tố đa năng Panasonic S36' ,
	100 , 5 , 1800000 , 
	N'Máy xay sinh tố Panasonic thiết kế màu trắng sang trọng, công suất 700W, lưỡi dao sắc bén, cùng công nghệ đảo trộn V&M, cho bạn những ly sinh tố thơm ngon, bổ dưỡng hay chế biến những bữa ăn đa dạng từ thịt và cá.' ,
	'may-xay-sinh-to-da-nang-panasonic-s36' ,
	4 , 4
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/may-xay-nau-da-nang-kangaroo-kg175hb1
( 
	37 , 
	N'Máy xay nấu đa năng Kangaroo S37' ,
	100 , 14 , 3420000 , 
	N'Máy xay nấu đa năng Kangaroo thiết kế chắc chắn, sang trọng, tạo điểm nhấn cho không gian bếp Việt.' ,
	'may-xay-nau-da-nang-kangaroo-s37' ,
	4 , 2
) ,

-- https://www.dienmayxanh.com/may-xay-sinh-to/kangaroo-kgbl600x
( 
	38 , 
	N'Máy xay sinh tố Kangaroo S38' ,
	100 , 25 , 1490000 , 
	N'Máy xay sinh tố Kangaroo KGBL600X với 5 tốc độ xay, 1 chế độ nhồi cùng công suất 600W mạnh mẽ và lưỡi dao 6 cánh có răng cưa giúp xay nhanh nhuyễn mịn. Sản phẩm đáp ứng tốt nhu cầu xay sinh tố, rau củ, đá nhỏ sử dụng trong gia đình.' ,
	'may-xay-sinh-to-kangaroo-s38' ,
	4 , 2
) ,


-- Lọc không khí
-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-kangaroo-kg40ap
( 
	39 , 
	N'Máy lọc không khí Kangaroo 50W S39' ,
	100 , 14 , 6824000 , 
	N'Máy lọc không khí Kangaroo nhỏ gọn, thiết kế sang trọng, mang nét hiện đại và tạo điểm nhấn cho không gian sử dụng.' ,
	'may-loc-khong-khi-kangaroo-50w-s39' ,
	5 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-sharp-fp-j80ev-h
( 
	40 , 
	N'Máy lọc không khí Sharp 48W S40' ,
	100 , 8 , 8390000 , 
	N'Máy lọc không khí với thiết kế tông màu đen bóng tinh tế, tạo điểm nhấn hiện đại, sang trọng phù hợp cho diện tích dưới 62 m².' ,
	'may-loc-khong-khi-sharp-48w-s40' ,
	5 , 7
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/sunhouse-shd-35ap9735
( 
	41 , 
	N'Máy lọc không khí Sunhouse 50W S41' ,
	100 , 25 , 4310000 , 
	N'Máy lọc không khí Sunhouse lọc sạch không khí hiệu quả và lọc được bụi PM 2.5
Máy lọc không khí sử dụng kết hợp giữa hệ thống màng lọc cao cấp, bộ cảm biến bụi và mùi theo thực tế chất lượng không khí cùng công nghệ ion âm hiện đại giúp tăng cường hiệu quả lọc. Nhờ thế mà đảm bảo lọc sạch được bụi bẩn, khói mùi, các tác nhân gây dị ứng và cả bụi mịn PM 2.5 trong nhà.' ,
	'may-loc-khong-khi-sunhouse-50w-s41' ,
	5 , 8
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-samsung-ax60r5080wd-sv
( 
	42 , 
	N'Máy lọc không khí Samsung 60W S42' ,
	100 , 6 , 10190000 , 
	N'Máy lọc không khí Samsung kết cấu vững chắc, màu sắc trang nhã, có bánh xe di chuyển linh hoạt 
Máy thiết kế có thể đặt sát tường, tiện sử dụng và bảo quản.' ,
	'may-loc-khong-khi-samsung-60w-s42' ,
	5 , 5
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/may-loc-khong-khi-lg-puricare-aerotower-mau-xanh-la
( 
	43 , 
	N'Máy lọc không khí LG PuriCare AeroTower màu xanh lá 50W S43' ,
	100 , 7 , 22500000 , 
	N'Máy lọc không khí LG PuriCare AeroTower màu xanh lá thiết kế độc đáo, màu sắc trang nhã, phù hợp với nhiều không gian, lọc được nhiều loại bụi mịn với bộ lọc 3 lớp: màng lọc thô, màng lọc TRUE HEPA và màng lọc than hoạt tính giúp không khí được lọc sạch hơn trong phạm vi dưới 76m2, điều khiển từ xa thông qua ứng dụng LG ThinQ và remote, cảm biến bụi, nhiệt độ và độ ẩm giúp bạn tiện theo dõi tình trạng không khí, độ ẩm và nhiệt độ trong nhà, cảm biến chất lượng không khí thông qua 4 màu sắc khác nhau giúp bạn tùy chọn được chế độ lọc phù hợp.' ,
	'may-loc-khong-khi-lg-puricare-aerotower-xanh-la-50w-s43' ,
	5 , 3
) ,

-- https://www.dienmayxanh.com/may-loc-khong-khi/cuckoo-cac-g0910fn
( 
	44 , 
	N'Máy lọc không khí Cuckoo 50W S44' ,
	100 , 29 , 4050000 , 
	N'Máy lọc không khí Cuckoo kiểu dáng nhỏ gọn, trọng lượng nhẹ 5.9 kg, công suất 50W phù hợp với diện tích 31.2m2.' ,
	'may-loc-khong-khi-cuckoo-50w-s44' ,
	5 , 1
) ,


-- Hút bụi
-- https://www.dienmayxanh.com/robot-hut-bui/samsung-vr30t85513w-sv
( 
	45 , 
	N'Robot hút bụi Samsung S45' ,
	100 , 10 , 19990000 , 
	N'Lực hút mạnh mẽ 4200 Pa với động cơ Digital inverter, tối ưu luồng khí hút bằng cánh quạt siêu âm
Bên cạnh đó, robot hút bụi Samsung còn có tích hợp chức năng thông minh Power Control giúp nhận diện bề mặt và lượng bụi, tự động điều chỉnh công suất hút phù hợp để làm sạch hiệu quả hơn.' ,
	'robot-hut-bui-samsung-s45' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/may-hut-bui/cam-tay-samsung-vs15a6031r1-sv
( 
	46 , 
	N'Máy hút bụi không dây Samsung S46' ,
	100 , 6 , 7990000 , 
	N'Tạo ra lực hút mạnh vượt trội nhờ công nghệ hút đa lốc xoáy Jet Cyclone
Samsung VS15A6031R1/SV trang bị hệ thống hút đa lốc xoáy Jet Cyclone tạo ra lực hút mạnh vượt trội qua 9 trục hút xoáy và 27 cửa hút gió, giảm thiểu lực hút hao hụt. Công nghệ Jet Cyclone còn có tác dụng lọc bụi mịn hiệu quả, trả lại không khí sạch cho ngôi nhà bạn tối ưu.' ,
	'may-hut-bui-khong-day-samsung-s46' ,
	6 , 5
) ,

-- https://www.dienmayxanh.com/may-hut-bui/philips-fc6728
( 
	47 , 
	N'Máy hút bụi không dây Philips S47' ,
	100 , 35 , 10499000 , 
	N' Máy hút bụi cầm tay thiết kế nhỏ gọn, dễ dàng tháo lắp, di chuyển và sử dụng bất cứ đâu nhà ở, công ty.' ,
	'may-hut-bui-khong-day-philips-s47' ,
	6 , 10
) ,

-- https://www.dienmayxanh.com/may-hut-bui/may-hut-bui-khong-day-panasonic-mc-sb30jw049
( 
	48 , 
	N'Máy hút bụi không dây Panasonic S48' ,
	100 , 0 , 7690000 , 
	N'Máy hút bụi không dây Panasonnic với khối lượng chỉ 1.6 kg nhẹ nhàng, dễ dàng di chuyển vệ sinh bằng một tay
Thuận tiện hút bụi tại các vị trí cao như cửa sổ, giá sách mà không gây cảm giác nặng nề với khối lượng 1.6 kg (tương đương 1 chai nước 1.5 lít). Đồng thời thiết kế cầm tay không dây cũng giúp dọn dẹp các khu vực riêng biệt như cầu thang, nội thất ô tô một cách dễ dàng.' ,
	'may-hut-bui-khong-day-panasonic-s48' ,
	6 , 4
) ,

-- https://www.dienmayxanh.com/may-hut-bui/samsung-vcc8835v37-xsv
( 
	49 , 
	N'Máy hút bụi dạng hộp Samsung S49' ,
	100 , 13 , 3290000 , 
	N'Máy hút bụi Samsung VCC8835V37/XSV được thiết kế gọn gàng, đơn giản.' ,
	'may-hut-bui-dang-hop-samsung-s49' ,
	6 , 5
) ,


-- Lọc nước
-- https://www.dienmayxanh.com/may-loc-nuoc/kangaroo-kg99a-vtu-kg
( 
	50 , 
	N'Máy lọc nước RO Kangaroo VTU 9 lõi S50' ,
	100 , 32 , 6690000 , 
	N'Máy lọc nước Kangaroo có thiết kế tủ đứng với màu sắc hiện đại, phù hợp với không gian gia đình, văn phòng làm việc hay cửa hàng ăn uống.' ,
	'may-loc-nuoc-ro-kangaroo-vtu-9-loi-s50' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-ro-sunhouse-sha8889k-9-loi-kg
( 
	51 , 
	N'Máy lọc nước RO Sunhouse 9 lõi S51' ,
	100 , 30 , 7490000 , 
	N'Máy lọc nước Sunhouse với kiểu dáng tủ đứng gọn đẹp, vỏ tủ kính cường lực tràn viền màu đen sang trọng, họa tiết đơn giản mà tinh tế, giữ sản phẩm hài hòa trong không gian sống hiện đại.' ,
	'may-loc-nuoc-ro-sunhouse-9-loi-s51' ,
	7 , 8
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/kangaroo-kg10a3
( 
	52 , 
	N'Máy lọc nước RO nóng nguội lạnh Kangaroo 10 lõi S52' ,
	100 , 27 , 9900000 , 
	N'Máy lọc nước RO Kangaroo KG10A3 10 lõi có thiết kế hiện đại, sang trọng, sử dụng được trong gia đình như phòng khách, nhà bếp hoặc dùng trong văn phòng, nhà hàng, khách sạn.' ,
	'may-loc-nuoc-ro-kangaroo-10-loi-s52' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-ro-khong-vo-kangaroo-kg110-9-loi-kg
( 
	53 , 
	N'Máy lọc nước RO không vỏ Kangaroo 9 lõi S53' ,
	100 , 5 , 6990000 , 
	N'Máy lọc nước Kangaroo thiết kế không vỏ có thể lắp âm gọn gàng trong tủ bếp, tiết kiệm không gian sử dụng.' ,
	'may-loc-nuoc-ro-khong-vo-kangaroo-9-loi-s53' ,
	7 , 2
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/may-loc-nuoc-nong-lanh-ro-korihome-wpk-903
( 
	54 , 
	N'Máy lọc nước RO nóng lạnh Korihome 7 lõi S54' ,
	100 , 16 , 13340000 , 
	N'Vẻ đẹp tinh tế của máy lọc nước tại vòi thiết kế kiểu dáng phong cách hàn Quốc.' ,
	'may-loc-nuoc-ro-korihome-7-loi-s54' ,
	7 , 10
) ,

-- https://www.dienmayxanh.com/may-loc-nuoc/ion-kiem-panasonic-tk-as45-3-tam-dien-cuc
( 
	55 , 
	N'Máy lọc nước ion kiềm Panasonic 3 tấm điện cực S55' ,
	100 , 0 , 25500000 , 
	N'Máy lọc nước ion kiềm thương hiệu Panasonic toàn cầu, thành lập hơn 100 năm, đảm bảo chất lượng với sản phẩm nhập khẩu nguyên kiện từ Nhật Bản.' ,
	'may-loc-nuoc-ion-kiem-panasonic-3-tam-dien-cuc-s55' ,
	7 , 4
)

go

SET IDENTITY_INSERT products OFF
go

insert into roles ( id , [name] ) values
( 1	, N'Khách hàng' 			) ,
( 2	, N'Quản lý' 				) ,
( 3	, N'Nhân viên bán hàng' 	) ,
( 4	, N'Nhân viên giao hàng' 	)
go

-- Hash password -> password: 123
SET IDENTITY_INSERT users ON
insert into users ( id , username , fullname , hashPassword , email , phone , createdDate , isEnabled , roleId ) values
( 1	, N'ql1' , N'Quản Lý Một' 		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'ql1@gmail.com' , '0200000001' , '2021-01-01' , 1 , 2 ) ,
( 2	, N'ql2' , N'Quản lý Hai'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'ql2@gmail.com' , '0200000002' , '2021-01-01' , 1 , 2 ) ,
( 3	, N'bh1' , N'Bán Hàng Một'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'bh1@gmail.com' , '0300000001' , '2021-01-01' , 1 , 3 ) ,
( 4	, N'bh2' , N'Bán Hàng Một'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'bh2@gmail.com' , '0300000002' , '2021-01-01' , 1 , 3 ) ,
( 5	, N'gh1' , N'Giao Hàng Một' 	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'gh1@gmail.com' , '0400000001' , '2021-01-01' , 1 , 4 ) ,
( 6	, N'gh2' , N'Giao Hàng Hai' 	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'gh2@gmail.com' , '0400000002' , '2021-01-01' , 1 , 4 ) ,

( 7	, N'kh1' , N'Khách Hàng Một'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh1@gmail.com' , '0100000001' , '2021-10-01' , 1 , 1 ) ,
( 8	, N'kh2' , N'Khách Hàng Hai'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh2@gmail.com' , '0100000002' , '2021-10-05' , 1 , 1 ) ,
( 9	, N'kh3' , N'Khách Hàng Ba'		, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh3@gmail.com' , '0100000003' , '2021-10-20' , 1 , 1 ) ,
( 10, N'kh4' , N'Khách Hàng Bốn'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh4@gmail.com' , '0100000004' , '2021-11-03' , 1 , 1 ) ,
( 11, N'kh5' , N'Khách Hàng Năm'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh5@gmail.com' , '0100000005' , '2021-11-20' , 1 , 1 ) ,
( 12, N'kh6' , N'Khách Hàng Sáu'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh6@gmail.com' , '0100000006' , '2021-11-20' , 1 , 1 ) ,
( 13, N'kh7' , N'Khách Hàng Bảy'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh7@gmail.com' , '0100000007' , '2021-12-30' , 1 , 1 ) ,
( 14, N'kh8' , N'Khách Hàng Tám'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh8@gmail.com' , '0100000008' , '2022-01-09' , 1 , 1 ) ,
( 15, N'kh9' , N'Khách Hàng Chín'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh9@gmail.com' , '0100000009' , '2022-02-02' , 1 , 1 ) ,
( 16, N'kh10', N'Khách Hàng Mười'	, '$2a$10$7YIj5SGLAAev58xzTj6y3Owj/0e9ZVBZy9Hoc0nXxeysm8wovQUY6' , 'kh10@gmail.com', '0100000010' , '2022-02-20' , 1 , 1 )
go

SET IDENTITY_INSERT users OFF
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
go


SET IDENTITY_INSERT favorites OFF
go

SET IDENTITY_INSERT reviews ON
insert into reviews ( id , createdDate , score , [description] , customerId , productId ) values
( 1 , '2022-2-22' , 3 , N'Sản phẩm tốt!' , 15 , 29 ) ,
( 2 , '2021-11-18' , 4 , N'Sản phẩm tốt!' , 12 , 22 ) ,
( 3 , '2022-1-22' , 4 , N'Sản phẩm tốt!' , 10 , 7 ) ,
( 4 , '2022-2-15' , 5 , N'Sản phẩm tốt!' , 11 , 17 ) ,
( 5 , '2022-1-14' , 4 , N'Sản phẩm tốt!' , 8 , 21 ) ,
( 6 , '2021-12-24' , 4 , N'Sản phẩm tốt!' , 13 , 18 ) ,
( 7 , '2022-2-15' , 3 , N'Sản phẩm tốt!' , 14 , 51 ) ,
( 8 , '2021-10-15' , 4 , N'Sản phẩm tốt!' , 9 , 51 ) ,
( 9 , '2022-2-6' , 2 , N'Sản phẩm tốt!' , 10 , 36 ) ,
( 10 , '2022-1-23' , 3 , N'Sản phẩm tốt!' , 14 , 8 ) ,
( 11 , '2021-11-7' , 1 , N'Sản phẩm tốt!' , 9 , 9 ) ,
( 12 , '2021-10-18' , 2 , N'Sản phẩm tốt!' , 11 , 45 ) ,
( 13 , '2022-1-5' , 5 , N'Sản phẩm tốt!' , 11 , 19 ) ,
( 14 , '2022-2-16' , 1 , N'Sản phẩm tốt!' , 8 , 20 ) ,
( 15 , '2021-11-6' , 3 , N'Sản phẩm tốt!' , 13 , 28 ) ,
( 16 , '2022-1-9' , 4 , N'Sản phẩm tốt!' , 12 , 50 ) ,
( 17 , '2021-10-28' , 1 , N'Sản phẩm tốt!' , 11 , 24 ) ,
( 18 , '2022-1-16' , 4 , N'Sản phẩm tốt!' , 13 , 32 ) ,
( 19 , '2021-12-3' , 2 , N'Sản phẩm tốt!' , 16 , 5 ) ,
( 20 , '2021-10-14' , 3 , N'Sản phẩm tốt!' , 13 , 35 ) ,
( 21 , '2021-11-23' , 4 , N'Sản phẩm tốt!' , 11 , 21 ) ,
( 22 , '2022-2-13' , 2 , N'Sản phẩm tốt!' , 15 , 20 ) ,
( 23 , '2021-10-8' , 3 , N'Sản phẩm tốt!' , 15 , 16 ) ,
( 24 , '2021-12-12' , 3 , N'Sản phẩm tốt!' , 9 , 14 ) ,
( 25 , '2022-2-2' , 4 , N'Sản phẩm tốt!' , 13 , 7 ) ,
( 26 , '2022-1-11' , 5 , N'Sản phẩm tốt!' , 8 , 9 ) ,
( 27 , '2022-2-21' , 3 , N'Sản phẩm tốt!' , 15 , 44 ) ,
( 28 , '2021-12-27' , 2 , N'Sản phẩm tốt!' , 10 , 21 ) ,
( 29 , '2022-1-12' , 3 , N'Sản phẩm tốt!' , 13 , 14 ) ,
( 30 , '2022-2-28' , 3 , N'Sản phẩm tốt!' , 16 , 43 ) ,
( 31 , '2021-11-17' , 3 , N'Sản phẩm tốt!' , 12 , 14 ) ,
( 32 , '2022-2-16' , 5 , N'Sản phẩm tốt!' , 8 , 32 ) ,
( 33 , '2022-1-28' , 3 , N'Sản phẩm tốt!' , 12 , 38 ) ,
( 34 , '2022-1-29' , 4 , N'Sản phẩm tốt!' , 13 , 26 ) ,
( 35 , '2021-11-5' , 3 , N'Sản phẩm tốt!' , 14 , 15 ) ,
( 36 , '2021-11-20' , 3 , N'Sản phẩm tốt!' , 13 , 3 ) ,
( 37 , '2022-1-6' , 2 , N'Sản phẩm tốt!' , 9 , 41 ) ,
( 38 , '2022-2-12' , 3 , N'Sản phẩm tốt!' , 8 , 49 ) ,
( 39 , '2021-11-11' , 2 , N'Sản phẩm tốt!' , 13 , 12 ) ,
( 40 , '2022-2-27' , 5 , N'Sản phẩm tốt!' , 11 , 27 ) ,
( 41 , '2022-1-10' , 5 , N'Sản phẩm tốt!' , 11 , 37 ) ,
( 42 , '2022-1-26' , 3 , N'Sản phẩm tốt!' , 9 , 40 ) ,
( 43 , '2021-10-22' , 3 , N'Sản phẩm tốt!' , 10 , 25 ) ,
( 44 , '2021-12-18' , 3 , N'Sản phẩm tốt!' , 13 , 42 ) ,
( 45 , '2021-10-5' , 5 , N'Sản phẩm tốt!' , 15 , 5 ) ,
( 46 , '2022-1-22' , 3 , N'Sản phẩm tốt!' , 7 , 14 ) ,
( 47 , '2022-2-14' , 5 , N'Sản phẩm tốt!' , 12 , 4 ) ,
( 48 , '2022-2-28' , 3 , N'Sản phẩm tốt!' , 8 , 27 ) ,
( 49 , '2021-10-12' , 4 , N'Sản phẩm tốt!' , 12 , 34 ) ,
( 50 , '2021-12-19' , 4 , N'Sản phẩm tốt!' , 15 , 12 ) ,
( 51 , '2022-1-16' , 3 , N'Sản phẩm tốt!' , 15 , 1 ) ,
( 52 , '2021-10-12' , 2 , N'Sản phẩm tốt!' , 15 , 22 ) ,
( 53 , '2021-11-14' , 5 , N'Sản phẩm tốt!' , 15 , 15 ) ,
( 54 , '2021-12-13' , 2 , N'Sản phẩm tốt!' , 8 , 34 ) ,
( 55 , '2022-1-2' , 4 , N'Sản phẩm tốt!' , 15 , 13 ) ,
( 56 , '2021-10-14' , 4 , N'Sản phẩm tốt!' , 11 , 49 ) ,
( 57 , '2022-2-14' , 5 , N'Sản phẩm tốt!' , 10 , 4 ) ,
( 58 , '2021-10-26' , 3 , N'Sản phẩm tốt!' , 12 , 6 ) ,
( 59 , '2021-11-4' , 3 , N'Sản phẩm tốt!' , 10 , 9 ) ,
( 60 , '2021-11-5' , 2 , N'Sản phẩm tốt!' , 13 , 34 ) ,
( 61 , '2022-2-10' , 1 , N'Sản phẩm tốt!' , 9 , 30 ) ,
( 62 , '2021-10-27' , 3 , N'Sản phẩm tốt!' , 8 , 33 ) ,
( 63 , '2021-11-3' , 4 , N'Sản phẩm tốt!' , 13 , 9 ) ,
( 64 , '2021-11-12' , 5 , N'Sản phẩm tốt!' , 8 , 13 ) ,
( 65 , '2021-10-8' , 3 , N'Sản phẩm tốt!' , 7 , 42 ) ,
( 66 , '2022-2-22' , 3 , N'Sản phẩm tốt!' , 13 , 53 ) ,
( 67 , '2021-11-10' , 2 , N'Sản phẩm tốt!' , 13 , 55 ) ,
( 68 , '2022-2-14' , 2 , N'Sản phẩm tốt!' , 10 , 16 ) ,
( 69 , '2022-1-17' , 1 , N'Sản phẩm tốt!' , 10 , 8 ) ,
( 70 , '2022-1-26' , 4 , N'Sản phẩm tốt!' , 8 , 52 ) ,
( 71 , '2022-1-19' , 4 , N'Sản phẩm tốt!' , 15 , 39 ) ,
( 72 , '2022-2-24' , 3 , N'Sản phẩm tốt!' , 14 , 18 ) ,
( 73 , '2021-12-23' , 2 , N'Sản phẩm tốt!' , 13 , 27 ) ,
( 74 , '2022-2-24' , 3 , N'Sản phẩm tốt!' , 11 , 4 ) ,
( 75 , '2022-2-16' , 3 , N'Sản phẩm tốt!' , 16 , 29 ) ,
( 76 , '2022-1-16' , 3 , N'Sản phẩm tốt!' , 14 , 34 ) ,
( 77 , '2022-2-15' , 5 , N'Sản phẩm tốt!' , 13 , 5 ) ,
( 78 , '2021-10-2' , 4 , N'Sản phẩm tốt!' , 12 , 49 ) ,
( 79 , '2022-2-20' , 4 , N'Sản phẩm tốt!' , 12 , 16 ) ,
( 80 , '2022-2-7' , 2 , N'Sản phẩm tốt!' , 14 , 32 ) ,
( 81 , '2021-10-23' , 4 , N'Sản phẩm tốt!' , 8 , 17 ) ,
( 82 , '2022-2-17' , 2 , N'Sản phẩm tốt!' , 10 , 54 ) ,
( 83 , '2022-2-9' , 3 , N'Sản phẩm tốt!' , 9 , 20 ) ,
( 84 , '2021-11-4' , 2 , N'Sản phẩm tốt!' , 12 , 52 ) ,
( 85 , '2021-11-23' , 1 , N'Sản phẩm tốt!' , 11 , 3 ) ,
( 86 , '2021-10-29' , 3 , N'Sản phẩm tốt!' , 15 , 17 ) ,
( 87 , '2021-12-8' , 2 , N'Sản phẩm tốt!' , 13 , 10 ) ,
( 88 , '2021-12-11' , 2 , N'Sản phẩm tốt!' , 12 , 17 ) ,
( 89 , '2022-2-11' , 4 , N'Sản phẩm tốt!' , 7 , 28 ) ,
( 90 , '2021-12-1' , 4 , N'Sản phẩm tốt!' , 12 , 32 ) ,
( 91 , '2021-12-24' , 3 , N'Sản phẩm tốt!' , 13 , 25 ) ,
( 92 , '2021-12-5' , 3 , N'Sản phẩm tốt!' , 15 , 21 ) ,
( 93 , '2022-1-18' , 5 , N'Sản phẩm tốt!' , 7 , 50 ) ,
( 94 , '2022-1-26' , 5 , N'Sản phẩm tốt!' , 10 , 10 ) ,
( 95 , '2022-1-5' , 2 , N'Sản phẩm tốt!' , 15 , 38 ) ,
( 96 , '2022-2-21' , 3 , N'Sản phẩm tốt!' , 12 , 11 ) ,
( 97 , '2021-11-27' , 1 , N'Sản phẩm tốt!' , 9 , 36 ) ,
( 98 , '2022-1-26' , 4 , N'Sản phẩm tốt!' , 12 , 47 ) ,
( 99 , '2021-11-16' , 3 , N'Sản phẩm tốt!' , 15 , 47 ) ,
( 100 , '2021-11-13' , 4 , N'Sản phẩm tốt!' , 16 , 34 )
go

SET IDENTITY_INSERT reviews OFF
go



use G2Shop

update products set [description] =N'
	<h5><b>Nồi cơm điện Kangaroo kiểu dáng mềm mại, hiện đại, trẻ trung bắt mắt mới 2 màu đỏ và trắng, tạo điểm nhấn cho gian bếp gia đình.</b></h5>
	<h5><b>Dung tích nồi 1.8 lít phục vụ tốt cho các gia đình 4 – 6 người ăn.</b></h5>
	<h5><b>Nồi cơm nắp gài dễ sử dụng với hệ nút nhấn điện tử có màn hình hiển thị, đa chức năng nấu tùy chọn theo nhu cầu.</b></h5>
	<p>
	Nồi có thể nấu cơm, nấu súp, làm bánh, hầm, nấu cháo, nấu thịt gà và giữ ấm, rất tiện lợi cho các bữa ăn gia đình.
	<br>
	Nấu cơm chín nhanh với thời gian mặc định 30 phút và tối thiểu 20 phút là bạn đã có bữa cơm ngon cùng với gia đình của mình.
	</p>
	<h5><b>Lòng nồi 2 lớp phủ hợp kim nhôm tráng men chống dính, dày 2 mm, bền bỉ, chống dính cháy, cho cơm chín ngon, dễ lau chùi sau khi dùng.</b></h5>
	<h5><b>Mâm nhiệt đáy nồi bằng chất liệu nhôm nguyên chất gia nhiệt nhanh, nấu cơm chín mau, tiết kiệm thời gian và điện năng tiêu thụ.</b></h5>
	<h5><b>Công nghệ ủ ấm 3D giúp nồi giữ ấm cơm lâu, cơm ngon ấm nóng sẵn sàng phục vụ gia đình trong nhiều giờ.</b></h5>
	<h5><b>Kèm thêm xửng hấp cho người dùng chế biến các món hấp đơn giản như rau củ, nấu xôi, làm bánh, ...</b></h5>
	<p>
	Nồi cơm điện nắp gài Kangaroo 1.8L sản phẩm đẹp, dễ dùng, dùng bền, phục vụ tốt cho từng bữa ăn gia đình.
	</p>
' where id = 1
go

update products set [description] =N'
	<h5><b>Nồi cơm nắp gài Kangaroo kiểu dáng đơn giản, họa tiết hoa Hàn Quốc trên thân nồi đẹp mắt.</b></h5>
	<p>
	Thiết kế nổi bật trên nền đỏ - trắng chủ đạo cho tổng thể thiết kế hiện đại, có tính thẩm mỹ cao. Dung tích 1.8 lít đáp ứng nhu cầu nấu cơm cho gia đình có từ 4 - 6 thành viên.
	</p>
	<h5><b>Lòng nồi dày 1.001 mm bằng hợp kim nhôm phủ chống dính bền bỉ, an toàn khi dùng, hạn chế cơm dính cháy, dễ lau chùi.</b></h5>
	<h5><b>Cơm chín nhanh chóng khoảng 20 - 30 phút với công suất mạnh mẽ 700W, công nghệ nấu 1D.</b></h5>
	<p>
	Trong nồi có trang bị 1 mâm nhiệt phẳng truyền nhiệt rộng, cho hiệu suất nấu cao.
	</p>
	<h5><b>Điều khiển nút gạt tùy chỉnh chức năng nấu - giữ ấm dễ sử dụng.</b></h5>
	<p>
	Chế độ giữ ấm 3D của nồi cơm điện giúp cơm chín đều, thơm ngon hơn.
	</p>
	<h5><b>Kiểm soát hơi nước, cho cơm bổ dưỡng, hạn chế nhão với van thoát hơi, khay hứng nước thừa và nắp trong dạng tổ ong.</b></h5>
	<h5><b>Có xửng hấp đi kèm nồi cơm điện Kangaroo cho bạn hấp bánh bao, rau củ,... thuận tiện.</b></h5>
	<h5><b>Lưu ý:</b></h5>
	<p>
	- Không vo gạo trực tiếp trong lòng nồi để hạn chế làm trầy lớp chống dính.
	<br>
	- Khi đang nấu cơm, không nên dùng khăn hoặc vật dụng để chặn van thoát hơi.
	<br>
	- Chùi rửa nồi sạch sẽ sau mỗi lần nấu để tránh ám mùi cho lần nấu tiếp theo.
	<br><br>
	Nồi cơm nắp gài Kangaroo 1.8 lít, sản phẩm của thương hiệu nổi tiếng Kangaroo - Việt Nam, sản xuất tại Trung Quốc, kết cấu gọn đẹp, màu sắc nổi bật, nấu cơm chín ngon, hứa hẹn sẽ là trợ thủ phòng bếp đắc lực cho bạn.
	</p>
' where id = 2
go

update products set [description] =N'
	Nồi cơm điện Sunhouse có màu trắng hồng nhẹ nhàng, xinh xắn, phù hợp với thị hiếu của nữ giới.
	Thân nồi cơm điện dày, kiểu nồi cơm nắp gài cho nồi giữ nhiệt tốt, cơm nóng ngon lâu.
	Nấu đủ cơm cho gia đình có 4 - 6 thành viên với dung tích 1.8 lít.
	Nút gạt thiết kế ở mặt trước thân nồi cho bạn chỉnh chức năng nấu và giữ ấm dễ dàng, linh hoạt.
	Lòng nồi 2 lớp dày 1.207 mm làm bằng hợp kim nhôm phủ lớp chống dính Whitford - USA, an toàn cho sức khỏe, nấu cơm chín ngon, tơi, hấp dẫn, làm sạch, vệ sinh đơn giản.
	Nấu cơm chín nhanh với công nghệ nấu 1D, công suất 700W, tiết kiệm điện năng của gia đình.
	Nồi có chế độ ủ ấm 3D cho khả năng giữ ấm cơm lâu đến 24 tiếng.
	Chỉ tiêu tốn khoảng 20 - 25 phút bạn đã có cơm nóng, thơm ngon để thưởng thức cùng gia đình.
	Hấp thức ăn đơn giản, thuận tiện với xửng hấp được tặng kèm nồi.
	Nồi cơm nắp gài Sunhouse 1.8 lít SHD8607W thiết kế đẹp, dùng nấu cơm nhanh, giá cả phải chăng, xứng đáng có mặt trong mọi gia đình.
' where id = 2
go