package com.fighting.fpoly_fighting.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.OrderDAO;
import com.fighting.fpoly_fighting.entity.Cart;
import com.fighting.fpoly_fighting.entity.CartItem;
import com.fighting.fpoly_fighting.entity.MailInfo;
import com.fighting.fpoly_fighting.entity.Order;
import com.fighting.fpoly_fighting.entity.OrderDetail;
import com.fighting.fpoly_fighting.entity.OrderInfo;
import com.fighting.fpoly_fighting.entity.OrderStatus;
import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.MailService;
import com.fighting.fpoly_fighting.service.OrderDetailService;
import com.fighting.fpoly_fighting.service.OrderService;
import com.fighting.fpoly_fighting.service.OrderStatusService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.StaffService;

@Service
public class OrderServiceImpl implements OrderService {
	
	@Autowired
	ServletContext app ;

	@Autowired
	MailService mailService ;
	
	@Autowired
	OrderDAO orderDao;
	
	@Autowired
	OrderStatusService orderStatusService ;
	
	@Autowired
	ProductService productService ;
	
	@Autowired
	StaffService staffService ;
	
	@Autowired
	OrderDetailService orderDetailService ;
	
	@Override
	public List< Order > findAll() {
		return orderDao.findAll( Sort.by( Direction.DESC , "createdDate" ) ) ;
	}

	@Override
	public List<Order> findByCustomerId( Long customerId , Sort sort ) {
		return orderDao.findByCustomerId( customerId , sort ) ;
	}

	@Override
	public void order( User user, Cart cart , OrderInfo orderInfo ) {
		final Order order = new Order() ;
		final OrderStatus orderStatus = orderStatusService.findById( 0 ) ;
		order.setReceiverFullname( orderInfo.getReceiverFullname() ) ;
		order.setReceiverAddress( orderInfo.getReceiverAddress() ) ;
		order.setReceiverPhone( orderInfo.getReceiverPhone() ) ;
		order.setNote( orderInfo.getNote() ) ;
		order.setCustomer( user ) ;
		order.setCreatedDate( new Date() ) ;
		order.setOrderStatus( orderStatus ) ;
		order.setShippingFee( 0. ) ;
		final Order newOrder = orderDao.save( order ) ;
		for( final CartItem item : cart.getItems() ) {
			final OrderDetail orderDetail = new OrderDetail() ;
			orderDetail.setOrder( newOrder ) ;
			orderDetail.setProduct( item.getProduct() ) ;
			orderDetail.setPrice( item.getProduct().getSalePrice() ) ;
			orderDetail.setQuantity( item.getQuantity() ) ;
			orderDetailService.create( orderDetail ) ;
		}
		final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
		final String dateS = dateFormat.format( new Date() ) ;
		try {
			final String link = "localhost:8080/khach-hang/lich-su-dat-hang/xem-don-hang?id=" + order.getId() ;
            final String body = "Qu?? kh??ch ???? ?????t h??ng th??nh c??ng v??o " + dateS + ".<br>"
            		+ "Qu?? kh??ch c?? th??? xem ????n h??ng ???? ?????t t???i link: [" + link + "].<br>" ;
            mailService.send( order.getCustomer().getEmail() , "[ ?????T H??NG TH??NH C??NG - ????N H??NG S??? " + order.getId() + " ] - G2SHOP" , body ) ;
		} catch( Exception ex ) {}
	}

	@Override
	public Order findById( Long orderId ) {
		return orderDao.findById( orderId ).get() ;
	}

	@Override
	public boolean cancel( Long orderId , User customer ) {
		final Order order = orderDao.findById( orderId ).get() ;
		if( !order.getCustomer().getId().equals( customer.getId() ) ) return false ;
		if( order.getOrderStatus().getId() != 0 ) return false ;
		final OrderStatus orderStatus = orderStatusService.findById( -1 ) ;
		order.setOrderStatus( orderStatus ) ;
		orderDao.save( order ) ;
		final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
		final String dateS = dateFormat.format( new Date() ) ;
		try {
			final String link = "localhost:8080/khach-hang/lich-su-dat-hang/xem-don-hang?id=" + order.getId() ;
            final String body = "????n h??ng s??? " + order.getId() + " ???? ???????c h???y v??o " + dateS + ".<br>"
            		+ "Qu?? kh??ch c?? th??? xem l???i ????n h??ng t???i link: [" + link + "].<br>" ;
            mailService.send( order.getCustomer().getEmail() , "[ H???Y ????N H??NG - S??? " + order.getId() + " ] - G2SHOP" , body ) ;
		} catch( Exception ex ) {}
		return true ;
	}

	@Override
	public List< Order > findAllByOrderStatusId( Integer id ) {
		return orderDao.findByOrderStatusId( id ) ;
	}

	@Override
	public Order update( Order order ) throws Exception {
		if( order.getId() != null && this.findById( order.getId() ) == null ) throw new Exception( "M?? ????n h??ng kh??ng t???n t???i!" ) ;
		return orderDao.save( order ) ;
	}
	
	@Override
	public Long countByOrderStatusIdAndShippinngStaffId(  Integer orderStatusId , Long shippingStaffId  ) {
		return orderDao.countByOrderStatusIdAndShippinngStaffId( orderStatusId , shippingStaffId ) ;
	}
	
	@Override
	public Order updateByLoggedInStaff( Long orderId , Integer orderStatusId , Double shippingFee ) throws Exception {
		final Order order = this.findById( orderId ) ;
		final User staff = staffService.getLoggedInStaff() ;
		final Long roleId = staff.getRole().getId() ;
		final Integer currentOrderStatusId = order.getOrderStatus().getId() ;
		if( orderStatusId == 1 ) {
			if( ( roleId != 2 && roleId != 3 ) || currentOrderStatusId != 0 ) throw new Exception( "B???n kh??ng c?? quy???n c???p nh???t ????n h??ng ho???c tr???ng th??i ????n h??ng kh??ng ph?? h???p ????? c???p nh???t!" ) ;
			for( final OrderDetail detail : order.getDetails() ) {
				if( detail.getQuantity() > detail.getProduct().getQuantity() - 1 ) throw new Exception( "M???t chi ti???t ????n h??ng ???? y??u c???u s??? l?????ng s???n ph???m nhi???u h??n s??? l?????ng t???n kho hi???n t???i s???n ph???m t????ng ???ng!" ) ;
			}
			order.setOrderStatus( orderStatusService.findById( 1 ) ) ;
			order.setConfirmingStaff( staff ) ;
			order.setShippingFee( shippingFee ) ;
			//giam so luong ton kho san pham tuong ung 
			for( final OrderDetail detail : order.getDetails() ) {
				final Product product = detail.getProduct() ;
				product.setQuantity( product.getQuantity() - detail.getQuantity() ) ;
				productService.update( product ) ;
			}
			return this.update( order ) ;
		}
		if( orderStatusId == 2 ) {
			if( roleId != 4 || currentOrderStatusId != 1 ) throw new Exception( "B???n kh??ng c?? quy???n c???p nh???t ????n h??ng ho???c tr???ng th??i ????n h??ng kh??ng ph?? h???p ????? c???p nh???t!" ) ;
			final Long count2 = this.countByOrderStatusIdAndShippinngStaffId( 2 , staff.getId() ) ;
			final Long count3 = this.countByOrderStatusIdAndShippinngStaffId( 3 , staff.getId() ) ;
			final Long count4 = this.countByOrderStatusIdAndShippinngStaffId( 4 , staff.getId() ) ;
			if( count2 + count3 + count4 > 0 ) throw new Exception( "B???n c???n ho??n t???t c??c ????n h??ng ??ang giao tr?????c khi nh???n giao 1 ????n h??ng kh??c!" ) ;
			order.setOrderStatus( orderStatusService.findById( 2 ) ) ;
			order.setShippingStaff( staff ) ;
			return this.update( order ) ;
		}
		if( orderStatusId == 3 || orderStatusId == 4 || orderStatusId == 5 ) {
			if( !order.getShippingStaff().getId().equals( staff.getId() ) ) throw new Exception( "B???n kh??ng ???????c ph??p c???p nh???t ????n h??ng ??ang giao c???a m???t nh??n vi??n kh??c!" ) ; 
			order.setOrderStatus( orderStatusService.findById( orderStatusId ) ) ;
			if( orderStatusId == 5 ) {
				order.setReceivedDate( new Date() ) ;
				try {
					this.downloadBill( order.getId() ) ;
					final String link = "localhost:8080/khach-hang/lich-su-dat-hang/xem-don-hang?id=" + order.getId() ;
		            final String body = "????n h??ng s??? " + order.getId() + " ???? ho??n t???t.<br>"
		            		+ "Qu?? kh??ch c?? th??? xem l???i ????n h??ng t???i link: [" + link + "].<br>"
		            		+ "Qu?? kh??ch xem H??A ????N B??N H??NG ???????c ????nh k??m trong mail.<br>"
		            		+ "C???m ??n Qu?? kh??ch h??ng ???? tin t?????ng v?? ???ng h??? G2Shop!" ;
		            final MailInfo mailInfo = new MailInfo( order.getCustomer().getEmail() , "[ HO??N T???T ????N H??NG - S??? " + order.getId() + " ] - G2SHOP" , body) ;
		            final String fileName = "HDBH-" + order.getId() + ".xlsx" ;
		            final String path = app.getRealPath( "/order-bills/" + fileName ) ;
		            final String[] attachments = new String[] { path } ;
		            mailInfo.setAttachments( attachments ) ;
		            mailService.send( mailInfo ) ;
				} catch ( Exception ex ) {} ;
			}
			return this.update( order ) ;
		}
		throw new Exception( "Tr???ng th??i ????n h??ng c???n c???p nh???t kh??ng ph?? h???p!" ) ;
	}

	@Override
	public List< Order > findAllByShippingStaffIdAndOrderStatusIds( Long shippingStaffId , Integer[] orderStatusIds ) {
		return orderDao.findAllByShippingStaffIdAndOrderStatusIds( shippingStaffId , orderStatusIds ) ;
	}

	@Override
	public Boolean downloadBill( Long id ) {
		final Order order = this.findById( id ) ;
		final List< OrderDetail > details = order.getDetails() ;
		final User customer = order.getCustomer() ;
		final User confirmingStaff = order.getConfirmingStaff() ;
		final User shippingStaff = order.getShippingStaff() ;
		final String confirmingStaffS = confirmingStaff == null ? "" : ( "#" + confirmingStaff.getId() + " - " + confirmingStaff.getFullname() + " ( S??T: " + confirmingStaff.getPhone() + " )" ) ;
		final String shippingStaffS = shippingStaff == null ? "" : ( "#" + shippingStaff.getId() + " - " + shippingStaff.getFullname() + " ( S??T: " + shippingStaff.getPhone() + " )" ) ;
		XSSFWorkbook workbook = new XSSFWorkbook() ;
        XSSFSheet sheet = workbook.createSheet( "H??a ????n b??n h??ng" ) ;
        XSSFRow row ;
        Cell cell ;
        int rowI = 0 ;
        int colI = 0 ;
        XSSFCellStyle cellStyle ;
        
        final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
        
        cellStyle = workbook.createCellStyle();
        cellStyle.setAlignment( HorizontalAlignment.CENTER ) ;
        cellStyle.setWrapText( true ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "G2Shop - Chuy??n ??i???n m??y & ??i???n t??? gia d???ng" ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "H??A ????N B??N H??NG S??? " + id ) ;
        
        cellStyle = workbook.createCellStyle();
        cellStyle.setWrapText( true ) ;
        
        row = sheet.createRow( rowI ++  ) ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ng??y xu???t:") ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( dateFormat.format( new Date() ) ) ;
        
        row = sheet.createRow( rowI ++  ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ng?????i ?????t h??ng:") ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( customer.getFullname() + " ( M?? KH: " + customer.getId() + " | S??T: " + customer.getPhone() + " )" ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ng??y ?????t h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( dateFormat.format( order.getCreatedDate() ) ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Y??u c???u th??m:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getNote() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ng?????i nh???n h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getReceiverFullname() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "S??T nh???n h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getReceiverPhone() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "?????a ch??? nh???n h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getReceiverAddress() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Danh m???c s???n ph???m ???? ?????t:" ) ;
        
        cellStyle = workbook.createCellStyle();
        cellStyle.setBorderTop( BorderStyle.THIN ) ;
        cellStyle.setBorderLeft( BorderStyle.THIN ) ;
        cellStyle.setBorderBottom( BorderStyle.THIN ) ;
        cellStyle.setBorderRight( BorderStyle.THIN ) ;
        cellStyle.setWrapText( true ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "STT" ) ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "M?? SP" ) ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "T??n s???n ph???m" ) ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "????n gi??" ) ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "S??? l?????ng" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "T???ng" ) ;

        for( int i = 0 ; i < details.size() ; i ++ ) {
        	final OrderDetail detail = details.get( i ) ;
        	row = sheet.createRow( rowI ++ ) ;
        	colI = 0 ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( i + 1 ) ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( detail.getProduct().getId() ) ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( detail.getProduct().getName() ) ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( detail.getPrice() ) ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( detail.getQuantity() ) ;
        	cell = row.createCell( colI ++ ) ;
        	cell.setCellStyle( cellStyle ) ;
        	cell.setCellValue( detail.getPrice() * detail.getQuantity() ) ;
        }
        
        cellStyle = workbook.createCellStyle();
        cellStyle.setWrapText( true ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "T???ng gi?? tr??? s???n ph???m:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getTotalProductCost() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Nh??n vi??n x??c nh???n:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( confirmingStaffS ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ph?? v???n chuy???n:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getShippingFee() ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Nh??n vi??n giao h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( shippingStaffS ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "Ng??y nh???n h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getReceivedDate() == null ? "" : dateFormat.format( order.getReceivedDate() ) ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ++ ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "T???ng gi?? tr??? ????n h??ng:" ) ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( order.getTotalCost() ) ;
        
        cellStyle = workbook.createCellStyle();
        cellStyle.setAlignment( HorizontalAlignment.CENTER ) ;
        cellStyle.setWrapText( true ) ;
        
        row = sheet.createRow( rowI ++ ) ;
        colI = 0 ;
        cell = row.createCell( colI ) ;
        cell.setCellStyle( cellStyle ) ;
        cell.setCellValue( "C???m ??n Qu?? kh??ch ???? tin t?????ng v?? ???ng h??? G2Shop!" ) ;
        
        for( int i = 0 ; i < 2 ; i ++ ) {
        	sheet.addMergedRegion( new CellRangeAddress( i , i , 0 , 5 ) ) ;
        }
        for( int i = 2 ; i < 9 ; i ++ ) {
        	sheet.addMergedRegion( new CellRangeAddress( i , i , 1 , 5 ) ) ;
        }
        sheet.addMergedRegion( new CellRangeAddress( 9 , 9 , 0 , 5 ) ) ;
        for( int i = 11 + details.size() ; i < 17 + details.size() ; i ++ ) {
        	sheet.addMergedRegion( new CellRangeAddress( i , i , 1 , 5 ) ) ;
        }
        sheet.addMergedRegion( new CellRangeAddress( 17 + details.size() , 17 + details.size() , 0 , 5 ) ) ;
        
        for( int i = 0 ; i < 6 ; i ++ ) {
        	 sheet.autoSizeColumn( i ) ;
        }
        
        final String fileName = "HDBH-" + id + ".xlsx" ;
        try {
        	final String path = app.getRealPath( "/order-bills/" + fileName ) ;
        	final FileOutputStream out = new FileOutputStream( new File( path ) ) ;
        	workbook.write( out ) ;
            out.close() ;
            workbook.close() ;
        } catch( Exception ex ) {
        	return false ;
        }
        return true ;
	}

}
