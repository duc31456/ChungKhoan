USE [master]
GO
/****** Object:  Database [CHUNGKHOAN]    Script Date: 5/12/2022 8:14:22 PM ******/
CREATE DATABASE [CHUNGKHOAN]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CHUNGKHOAN', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CHUNGKHOAN.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CHUNGKHOAN_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\CHUNGKHOAN_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CHUNGKHOAN] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CHUNGKHOAN].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CHUNGKHOAN] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET ARITHABORT OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CHUNGKHOAN] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CHUNGKHOAN] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CHUNGKHOAN] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CHUNGKHOAN] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CHUNGKHOAN] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CHUNGKHOAN] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CHUNGKHOAN] SET  MULTI_USER 
GO
ALTER DATABASE [CHUNGKHOAN] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CHUNGKHOAN] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CHUNGKHOAN] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CHUNGKHOAN] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [CHUNGKHOAN]
GO
/****** Object:  StoredProcedure [dbo].[CursorLoaiGD]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CursorLoaiGD]
    @OutCrsr CURSOR VARYING OUTPUT,
    @macp    NVARCHAR(10),
    @Ngay    NVARCHAR(10),
    @LoaiGD  CHAR
AS
    SET DATEFORMAT DMY;
    IF (@LoaiGD = 'M')
        SET @OutCrsr = CURSOR KEYSET FOR
        SELECT ID, NGAYDAT, SOLUONG, GIADAT FROM LENHDAT
        WHERE MACP = @macp
            AND DAY(NGAYDAT) = DAY(@Ngay)
            AND MONTH(NGAYDAT) = MONTH(@Ngay)
            AND YEAR(NGAYDAT) = YEAR(@Ngay)
            AND LOAIGD = @LoaiGD
            AND SOLUONG > 0
        ORDER BY GIADAT DESC,NGAYDAT;
    ELSE
        SET @OutCrsr = CURSOR KEYSET FOR
        SELECT ID,NGAYDAT,SOLUONG,GIADAT FROM LENHDAT
        WHERE MACP = @macp
            AND DAY(NGAYDAT) = DAY(@Ngay)
            AND MONTH(NGAYDAT) = MONTH(@Ngay)
            AND YEAR(NGAYDAT) = YEAR(@Ngay)
            AND LOAIGD = @LoaiGD
            AND SOLUONG > 0
        ORDER BY GIADAT, NGAYDAT;
    OPEN @OutCrsr;

GO
/****** Object:  StoredProcedure [dbo].[SP_CapNhat_GiavaSoluong_cuaBangGia]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[SP_CapNhat_GiavaSoluong_cuaBangGia]
    @macp NVARCHAR(10),@gia FLOAT,@soluong INT,@loaiGD CHAR,@loai NVARCHAR(4)
AS
    BEGIN
        -- Cập nhật Giá và Số lượng mua,bán của BANGGIA
        DECLARE @giaTot1 FLOAT,@giaTot2 FLOAT,@giaTot3 FLOAT,@soluong1 INT,
				@soluong2 INT,@soluong3 INT,@tongCoPhieuGiaKhacNhau INT,@homNay DATETIME;
        IF (@loaiGD = 'B')
            BEGIN
                SET @giaTot1 = (SELECT GIABAN1 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @giaTot2 = (SELECT GIABAN2 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @giaTot3 = (SELECT GIABAN3 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                
				SET @soluong1 = (SELECT SOLUONGB1 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @soluong2 = (SELECT SOLUONGB2 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @soluong3 = (SELECT SOLUONGB3 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);

                -- TH1: Nếu LENHDAT mới có giá tương ứng thì cộng, trừ dồn vào số lượng
                IF (@gia = @giaTot1 OR @gia = @giaTot2 OR @gia = @giaTot3)
                    BEGIN
                        IF (@gia = @giaTot1)
                            BEGIN
                                -- Nếu Cộng số lượng lệnh đặt
                                IF (@loai = 'CONG')
                                    SET @soluong1 += @soluong;
                                ELSE -- Nếu Trừ số lượng lệnh đặt
                                    SET @soluong1 -= @soluong;
                            END;
                        ELSE IF (@gia = @giaTot2)
                                 BEGIN
                                     IF (@loai = 'CONG')
                                         SET @soluong2 += @soluong;
                                     ELSE
                                         SET @soluong2 -= @soluong;
                                 END;
                        ELSE
                                 BEGIN
                                     IF (@loai = 'CONG')
                                         SET @soluong3 += @soluong;
                                     ELSE
                                         SET @soluong3 -= @soluong;
                                 END;
                    END;
                -- TH2: Nếu lệnh đặt mới có giá tốt hơn thì thay đổi lại bảng giá
                ELSE IF (@gia < @giaTot1 OR @gia < @giaTot2 OR @gia < @giaTot3)
                         BEGIN
                             IF (@gia < @giaTot1)
                                 BEGIN
                                     SET @giaTot3 = @giaTot2;
                                     SET @giaTot2 = @giaTot1;
                                     SET @giaTot1 = @gia;
                                     SET @soluong3 = @soluong2;
                                     SET @soluong2 = @soluong1;
                                     SET @soluong1 = @soluong;
                                 END;
                             ELSE IF (@gia < @giaTot2)
                                      BEGIN
                                          SET @giaTot3 = @giaTot2;
                                          SET @giaTot2 = @gia;
                                          SET @soluong3 = @soluong2;
                                          SET @soluong2 = @soluong;
                                      END;
                             ELSE IF (@gia < @giaTot3)
                                      BEGIN
                                          SET @giaTot3 = @gia;
                                          SET @soluong3 = @soluong;
                                      END;
                         END;
             --khi chưa có dữ liệu từ 3 column giá(đầu vào mặc định = 0)
                ELSE IF (@giaTot1 = 0 OR @giaTot2 = 0 OR @giaTot3 = 0)
                         BEGIN
                             IF (@giaTot1 = 0)
                                 BEGIN
                                     SET @giaTot1 = @gia;
                                     SET @soluong1 = @soluong;
                                 END;
                             ELSE IF (@giaTot2 = 0)
                                      BEGIN
                                          SET @giaTot2 = @gia;
                                          SET @soluong2 = @soluong;
                                      END;
                             ELSE 
                                      BEGIN
                                          SET @giaTot3 = @gia;
                                          SET @soluong3 = @soluong;
                                      END;
                         END;
                -- Nếu số lượng của 1 trong 3 cổ phiếu có giá tốt nhất bằng 0 trên bảng giá thì refesh lại
                IF (@soluong1 = 0 OR @soluong2 = 0 OR @soluong3 = 0)
                    EXEC SP_RefreshBangGia @macp,@loaiGD;
                ELSE
                    UPDATE dbo.BANGGIATRUCTUYEN_LO
                    SET    GIABAN1 = @giaTot1,
                           GIABAN2 = @giaTot2,
                           GIABAN3 = @giaTot3,
                           SOLUONGB1 = @soluong1,
                           SOLUONGB2 = @soluong2,
                           SOLUONGB3 = @soluong3
                    WHERE MACP = @macp;
            END;
   --trường hợp 2: lệnh mua(tương tự)
        ELSE
		BEGIN
                SET @giaTot1 = (SELECT GIAMUA1 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @giaTot2 = (SELECT GIAMUA2 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @giaTot3 = (SELECT GIAMUA3 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                
				SET @soluong1 = (SELECT SOLUONGM1 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @soluong2 = (SELECT SOLUONGM2 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp);
                SET @soluong3 = (SELECT SOLUONGM3 FROM  dbo.BANGGIATRUCTUYEN_LO Where MACP = @macp); 
 
                -- TH1
                IF (@gia = @giaTot1 OR @gia = @giaTot2 OR @gia = @giaTot3)
                    BEGIN
                        IF (@gia = @giaTot1)
                            BEGIN
                                IF (@loai = 'CONG')
                                    SET @soluong1 += @soluong;
                                ELSE 
                                    SET @soluong1 -= @soluong;
                            END;
                        ELSE IF (@gia = @giaTot2)
                                 BEGIN
                                     IF (@loai = 'CONG')
                                         SET @soluong2 += @soluong;
                                     ELSE
                                         SET @soluong2 -= @soluong;
                                 END;
                        ELSE
                                 BEGIN
                                     IF (@loai = 'CONG')
                                         SET @soluong3 += @soluong;
                                     ELSE
                                         SET @soluong3 -= @soluong;
                                 END;
                    END;
                -- TH2
                ELSE IF (@gia > @giaTot1 OR @gia > @giaTot2 OR @gia > @giaTot3)
                         BEGIN
                             IF (@gia > @giaTot1)
                                 BEGIN

                                     SET @giaTot3 = @giaTot2;
                                     SET @giaTot2 = @giaTot1;
                                     SET @giaTot1 = @gia;

                                     SET @soluong3 = @soluong2;
                                     SET @soluong2 = @soluong1;
                                     SET @soluong1 = @soluong;
                                 END;
                             ELSE IF (@gia > @giaTot2)
                                      BEGIN
                                          SET @giaTot3 = @giaTot2;
                                          SET @giaTot2 = @gia;
                                          SET @soluong3 = @soluong2;
                                          SET @soluong2 = @soluong;
                                      END;
                             ELSE IF (@gia > @giaTot3)
                                      BEGIN
                                          SET @giaTot3 = @gia;
                                          SET @soluong3 = @soluong;
                                      END;
                         END;
               ELSE IF (@giaTot1 = 0 OR @giaTot2 = 0 OR @giaTot3 = 0)
                         BEGIN
                             IF (@giaTot1 = 0)
                                 BEGIN
                                     SET @giaTot1 = @gia;
                                     SET @soluong1 = @soluong;
                                 END;
                             ELSE IF (@giaTot2 = 0)
                                      BEGIN
                                          SET @giaTot2 = @gia;
                                          SET @soluong2 = @soluong;
                                      END;
                             ELSE 
                                      BEGIN
                                          SET @giaTot3 = @gia;
                                          SET @soluong3 = @soluong;
                                      END;
                         END;
				--khi chưa có dữ liệu từ 3 column giá(đầu vào mặc định = 0)
                IF (@soluong1 = 0 OR @soluong2 = 0 OR @soluong3 = 0)
                    EXEC SP_RefreshBangGia @macp, @loaiGD;
                ELSE
                    UPDATE dbo.BANGGIATRUCTUYEN_LO
                    SET    GIAMUA1 = @giaTot1,
                           GIAMUA2 = @giaTot2,
                           GIAMUA3 = @giaTot3,
                           SOLUONGM1 = @soluong1,
                           SOLUONGM2 = @soluong2,
                           SOLUONGM3 = @soluong3
                    WHERE MACP = @macp;
            END;
    END;

GO
/****** Object:  StoredProcedure [dbo].[SP_CapNhatKhopLenhBangGia]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CapNhatKhopLenhBangGia]
    @macp NVARCHAR(10), @giaKhop FLOAT, @soluongKhop INT
AS
    BEGIN
        -- Cập nhật giá khớp + số lượng khớp + tăng giảm giá + tổng số trong bảng giá
        DECLARE @tangGiamGia FLOAT,
                @tongSoLuong INT,
                @giaKhopCu   FLOAT,
                @giaKhopMoi  FLOAT,
                @soluongGiaoDichKhopTrongNgay INT;
        SET @soluongGiaoDichKhopTrongNgay = (SELECT COUNT(1) FROM (SELECT ID FROM dbo.LENHDAT WHERE MACP = @macp) 
											AS lenhDat JOIN   dbo.LENHKHOP ON lenhDat.ID = LENHKHOP.IDLENHDAT
                                             WHERE  DAY(NGAYKHOP) = DAY(GETDATE())
                                                    AND MONTH(NGAYKHOP) = MONTH(GETDATE())
                                                    AND YEAR(NGAYKHOP) = YEAR(GETDATE()));
        -- Nếu số lượng giao dịch khớp trong ngày < 4(tổng < 2) thì tangGiamGia = 0
        IF (@soluongGiaoDichKhopTrongNgay < 4)
            SET @tangGiamGia = 0;
        ELSE
            BEGIN
                SET @giaKhopMoi = (SELECT TOP 1 GIAKHOP FROM (SELECT ID FROM dbo.LENHDAT
                                   WHERE MACP = @macp) AS lenhDat
                                   JOIN  dbo.LENHKHOP ON lenhDat.ID = LENHKHOP.IDLENHDAT
                                   WHERE
                                          DAY(NGAYKHOP) = DAY(GETDATE())
                                          AND MONTH(NGAYKHOP) = MONTH(GETDATE())
                                          AND YEAR(NGAYKHOP) = YEAR(GETDATE())
                                   ORDER BY
                                          IDKHOP DESC);
                SET @giaKhopCu = (SELECT GIAKHOP FROM (SELECT ID FROM dbo.LENHDAT
                                    WHERE MACP = @macp) AS lenhDat
                                    JOIN dbo.LENHKHOP ON lenhDat.ID = LENHKHOP.IDLENHDAT
                                  WHERE
                                         DAY(NGAYKHOP) = DAY(GETDATE())
                                         AND MONTH(NGAYKHOP) = MONTH(GETDATE())
                                         AND YEAR(NGAYKHOP) = YEAR(GETDATE())
                                  ORDER BY
                                         IDKHOP DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY);
                SET @tangGiamGia = @giaKhopMoi - @giaKhopCu;
            END;
			--tính tổng
        SET @tongSoLuong = (SELECT TONGSOLUONG FROM dbo.BANGGIATRUCTUYEN_LO WHERE MACP = @macp) + @soluongKhop;
        UPDATE dbo.BANGGIATRUCTUYEN_LO SET GIAKHOP = @giaKhop, SOLUONGKHOP = @soluongKhop, 
										   TANGGIAMGIA = @tangGiamGia, TONGSOLUONG = @tongSoLuong WHERE MACP = @macp;
    END;

GO
/****** Object:  StoredProcedure [dbo].[SP_CapNhatTrangThai]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CapNhatTrangThai]
	@idLenhDat INT, @slBanDau INT, @slLucSau int
AS
BEGIN
	-- Cập nhật Số Lượng và Trạng Thái của Lệnh Đặt dựa vào IDLenhDat
    IF(@slBanDau = @slLucSau)
		BEGIN
		    UPDATE dbo.LENHDAT
			SET SOLUONG = @slLucSau, TRANGTHAILENH = N'Chờ khớp'
			WHERE ID = @idLenhDat
		END
	ELSE IF(@slLucSau = 0)
		BEGIN
		    UPDATE dbo.LENHDAT
			SET SOLUONG = @slLucSau, TRANGTHAILENH = N'Khớp hết'
			WHERE ID = @idLenhDat
		END
	ELSE
		BEGIN
		    UPDATE dbo.LENHDAT
			SET SOLUONG = @slLucSau, TRANGTHAILENH = N'Khớp lệnh 1 phần'
			WHERE ID = @idLenhDat
		END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_ChenvaoLENHKHOP]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ChenvaoLENHKHOP]
@idLenhDat1 INT , @idLenhDat2 INT , @giaKhop FLOAT, @slKhop INT 
	-- chèn lệnh đầu vào và lệnh đặt cursor vào bảng lenhkhop sau khi khớp lệnh
AS 
BEGIN
	INSERT INTO dbo.LENHKHOP(NGAYKHOP,SOLUONGKHOP,GIAKHOP,IDLENHDAT)
	VALUES (GETDATE(), @slKhop,@giaKhop,@idLenhDat1);
	
	INSERT INTO dbo.LENHKHOP(NGAYKHOP,SOLUONGKHOP,GIAKHOP,IDLENHDAT)
	VALUES (GETDATE(), @slKhop,@giaKhop,@idLenhDat2)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_KHOPLENH_LO]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_KHOPLENH_LO]
    @idLenhDatMB INT,
    @macp        NVARCHAR(10),
    @Ngay        NVARCHAR(10),
    @LoaiGD      CHAR,
    @soluongMB   INT,
    @giadatMB    FLOAT
AS
    SET DATEFORMAT DMY;
    DECLARE @CrsrVar         CURSOR,
            @ngaydat         NVARCHAR(10),
            @soluong         INT,
            @giadat          FLOAT,
            @soluongkhop     INT,
            @giakhop         FLOAT,
            @idLenhDat       INT,
            @soLuongMBBanDau INT;
    IF (@LoaiGD = 'B')
        EXEC CursorLoaiGD @CrsrVar OUTPUT,@macp,@Ngay,'M';
    ELSE
        EXEC CursorLoaiGD @CrsrVar OUTPUT,@macp,@Ngay,'B';
    -- lấy số lượng ban đầu để kiểm tra với số lượng đầu vào sau khi khớp lệnh 
	SET @soLuongMBBanDau = @soluongMB;
    FETCH NEXT FROM @CrsrVar INTO @idLenhDat,@ngaydat,@soluong,@giadat;

    WHILE (@@FETCH_STATUS <> -1 AND @soluongMB > 0)
        BEGIN
		--trường hợp 1(B-M)
            IF (@LoaiGD = 'B')
                BEGIN
                    IF (@giadatMB <= @giadat)
                        BEGIN
                            IF @soluongMB >= @soluong
                                BEGIN
                                    SET @soluongkhop = @soluong;
                                    SET @giakhop = @giadat;
                                    SET @soluongMB = @soluongMB - @soluong;
									--cập nhật table lenhdat đối với lệnh đặt cursor
                                    UPDATE dbo.LENHDAT
                                    SET    SOLUONG = 0,TRANGTHAILENH = N'Khớp hết'
                                    WHERE CURRENT OF @CrsrVar;
									--cập nhật giá số lượng cursor lệnh đặt trong banggiatructuyen
                                    EXEC SP_CapNhat_GiavaSoluong_cuaBangGia @macp,@giadat,@soluong,'M','Tru';
                                END;
                            ELSE
                                BEGIN
                                    SET @soluongkhop = @soluongMB;
                                    SET @giakhop = @giadat;
									--cập nhật table lenhdat đối với lệnh đặt cursor
                                    UPDATE dbo.LENHDAT
                                    SET    SOLUONG = SOLUONG - @soluongMB,TRANGTHAILENH = N'Khớp lệnh 1 phần'
                                    WHERE CURRENT OF @CrsrVar;
                                    SET @soluongMB = 0;
									--cập nhật giá số lượng cursor lệnh đặt trong banggiatructuyen
                                    EXEC SP_CapNhat_GiavaSoluong_cuaBangGia @macp,@giadat,@soluongkhop,'M','Tru';
                                END;
                            -- Cập nhật table LENHKHOP, tạo 2 record tương ứng với lệnh mua và bán (cũ và mới)
                            EXEC SP_ChenvaoLENHKHOP @idLenhDatMB,@idLenhDat,@giakhop,@soluongkhop;
                            -- Cập nhật GIAKHOP + SOLUONGKHOP + TANGGIAMGIA + TONGSOLUONG trong BANGGIATRUCTUYEN_LO
                            EXEC SP_CapNhatKhopLenhBangGia @macp,@giakhop,@soluongkhop;
                        END;
                    ELSE
                        GOTO THOAT;
                END;
            -- Trường hợp 2(M-B)
			ELSE 
			BEGIN
                    IF (@giadatMB >= @giadat)
                        BEGIN
                            IF @soluongMB >= @soluong
                                BEGIN
                                    SET @soluongkhop = @soluong;
                                    SET @giakhop = @giadat;
                                    SET @soluongMB = @soluongMB - @soluong;
                              	--cập nhật table lenhdat đối với lệnh đặt cursor
                                    UPDATE dbo.LENHDAT
                                    SET SOLUONG = 0,TRANGTHAILENH = N'Khớp hết'
                                    WHERE CURRENT OF @CrsrVar;
                                    -- Cập nhật Gia + SoLuong của Table BANGGIATRUCTUYEN_LO đối với loại lệnh đặt Cursor (lệnh cũ)
                                    EXEC SP_CapNhat_GiavaSoluong_cuaBangGia @macp,@giadat,@soluong,'B','Tru';
                                END;
                            ELSE
                                BEGIN
                                    SET @soluongkhop = @soluongMB;
                                    SET @giakhop = @giadat;
									--cập nhật table lenhdat đối với lệnh đặt cursor
                                    UPDATE dbo.LENHDAT
                                    SET SOLUONG = SOLUONG - @soluongMB,TRANGTHAILENH = N'Khớp lệnh 1 phần'
                                    WHERE CURRENT OF @CrsrVar;
                                    SET @soluongMB = 0;
                                    EXEC SP_CapNhat_GiavaSoluong_cuaBangGia @macp,@giadat,@soluongkhop,'B','Tru';
                                END;
                            -- Cập nhật table LENHKHOP, tạo 2 record tương ứng với lệnh mua và bán (cũ và mới)
                            EXEC SP_ChenvaoLENHKHOP @idLenhDatMB,@idLenhDat,@giakhop,@soluongkhop;
                            -- Cập nhật GIAKHOP + SOLUONGKHOP + TANGGIAMGIA + TONGSOLUONG trong BANGGIATRUCTUYEN_LO
                            EXEC SP_CapNhatKhopLenhBangGia @macp,@giakhop,@soluongkhop;
                        END;
                    ELSE
                        GOTO THOAT;
                END;
            FETCH NEXT FROM @CrsrVar INTO @idLenhDat,@ngaydat,@soluong,@giadat;
        END;
    THOAT:
    -- Cập nhật SoLuong + TrangThaiLenh của table LENHDAT đối với lệnh đặt đầu vào
    EXEC SP_CapNhatTrangThai @idLenhDatMB,@soLuongMBBanDau,@soluongMB;
    -- Cập nhật Gia + SoLuong của Table BANGGIATRUCTUYEN_LO đối với loại lệnh đặt đầu vào
    EXEC SP_CapNhat_GiavaSoluong_cuaBangGia @macp,@giadatMB,@soluongMB,@LoaiGD,'CONG';
    CLOSE @CrsrVar;
    DEALLOCATE @CrsrVar;

GO
/****** Object:  StoredProcedure [dbo].[SP_LenhDatTotNhat]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LenhDatTotNhat]
    @OutCrsr CURSOR VARYING OUTPUT,
    @macp    NVARCHAR(10),
    @LoaiGD  CHAR
AS
    -- Mở Cursor giá và số lượng của cổ phiếu tốt nhất, sắp xếp theo đặc thù của LoaiGD trong hôm nay
    DECLARE @homNay DATETIME;
    SET @homNay = GETDATE();

    IF (@LoaiGD = 'B')
        SET @OutCrsr = CURSOR KEYSET FOR
        SELECT GIADAT, SUM(SOLUONG) AS soLuong FROM dbo.LENHDAT
        WHERE  MACP = @macp
               AND LOAIGD = @LoaiGD
               AND SOLUONG > 0
               AND DAY(NGAYDAT) = DAY(@homNay)
               AND MONTH(NGAYDAT) = MONTH(@homNay)
               AND YEAR(NGAYDAT) = YEAR(@homNay)
        GROUP BY GIADAT
        ORDER BY GIADAT OFFSET 0 ROW FETCH NEXT 3 ROWS ONLY;
    ELSE
        SET @OutCrsr = CURSOR KEYSET FOR
        SELECT GIADAT, SUM(SOLUONG) AS soLuong FROM dbo.LENHDAT
        WHERE  MACP = @macp
               AND LOAIGD = @LoaiGD
               AND SOLUONG > 0
               AND DAY(NGAYDAT) = DAY(@homNay)
               AND MONTH(NGAYDAT) = MONTH(@homNay)
               AND YEAR(NGAYDAT) = YEAR(@homNay)
        GROUP BY GIADAT
        ORDER BY GIADAT DESC OFFSET 0 ROW FETCH NEXT 3 ROWS ONLY;
    OPEN @OutCrsr;

GO
/****** Object:  StoredProcedure [dbo].[SP_RefreshBangGia]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[SP_RefreshBangGia]
    @macp   NVARCHAR(10),@loaiGD CHAR
AS
    BEGIN
        -- cập nhật giá + Số lượng mua,bán của bảng giá 
		--và nếu giá tốt nhất = 0 thì refresh lại để tìm giá tốt nhất
        DECLARE @Cursorr  CURSOR,
                @gia      FLOAT,
                @soluong  INT,
                @dem      INT,
                @gia1     FLOAT,
                @soluong1 INT,
                @gia2     FLOAT,
                @soluong2 INT,
                @gia3     FLOAT,
                @soluong3 INT;
        SET @dem = 0;
        SET @gia1 = 0;
        SET @gia2 = 0;
        SET @gia3 = 0;
        SET @soluong1 = 0;
        SET @soluong2 = 0;
        SET @soluong3 = 0;
        EXEC dbo.SP_LenhDatTotNhat @Cursorr OUTPUT,@macp,@loaiGD;
        FETCH NEXT FROM @Cursorr INTO @gia,@soluong;
        WHILE (@@FETCH_STATUS <> -1 AND @dem < 3)
            BEGIN
                IF (@dem = 0)
                    BEGIN
                        SET @gia1 = @gia;
                        SET @soluong1 = @soluong;
                    END;
                ELSE IF (@dem = 1)
                         BEGIN
                             SET @gia2 = @gia;
                             SET @soluong2 = @soluong;
                         END;
                ELSE
                         BEGIN
                             SET @gia3 = @gia;
                             SET @soluong3 = @soluong;
                         END;
                SET @dem += 1;
                FETCH NEXT FROM @Cursorr INTO @gia,@soluong;
            END;
			-- nếu là loại GD bán thì... 
        IF (@loaiGD = 'B')
            UPDATE dbo.BANGGIATRUCTUYEN_LO
            SET    GIABAN1 = @gia1,
                   SOLUONGB1 = @soluong1,
                   GIABAN2 = @gia2,
                   SOLUONGB2 = @soluong2,
                   GIABAN3 = @gia3,
                   SOLUONGB3 = @soluong3
            WHERE MACP = @macp;
			--nếu là loại GD mua thì...
        ELSE
            UPDATE dbo.BANGGIATRUCTUYEN_LO
            SET    GIAMUA1 = @gia1,
                   SOLUONGM1 = @soluong1,
                   GIAMUA2 = @gia2,
                   SOLUONGM2 = @soluong2,
                   GIAMUA3 = @gia3,
                   SOLUONGM3 = @soluong3
            WHERE MACP = @macp;
        CLOSE @Cursorr;
        DEALLOCATE @Cursorr;
    END;
GO
/****** Object:  Table [dbo].[BANGGIATRUCTUYEN_LO]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BANGGIATRUCTUYEN_LO](
	[MACP] [nchar](7) NOT NULL,
	[GIAMUA1] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIAMUA1]  DEFAULT ((0)),
	[SOLUONGM1] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGM1]  DEFAULT ((0)),
	[GIAMUA2] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIAMUA2]  DEFAULT ((0)),
	[SOLUONGM2] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGM2]  DEFAULT ((0)),
	[GIAMUA3] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIAMUA3]  DEFAULT ((0)),
	[SOLUONGM3] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGM3]  DEFAULT ((0)),
	[GIABAN1] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIABAN1]  DEFAULT ((0)),
	[SOLUONGB1] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGB1]  DEFAULT ((0)),
	[GIABAN2] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIABAN2]  DEFAULT ((0)),
	[SOLUONGB2] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGB2]  DEFAULT ((0)),
	[GIABAN3] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIABAN3]  DEFAULT ((0)),
	[SOLUONGB3] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGB3]  DEFAULT ((0)),
	[GIAKHOP] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_GIAKHOP]  DEFAULT ((0)),
	[SOLUONGKHOP] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_SOLUONGKHOP]  DEFAULT ((0)),
	[TANGGIAMGIA] [float] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_TANGGIAMGIA]  DEFAULT ((0)),
	[TONGSOLUONG] [int] NOT NULL CONSTRAINT [DF_BANGGIATRUCTUYEN_LO_TONGSOLUONG]  DEFAULT ((0)),
 CONSTRAINT [PK_BANGGIATRUCTUYEN_LO] PRIMARY KEY CLUSTERED 
(
	[MACP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LENHDAT]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LENHDAT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MACP] [nchar](7) NOT NULL,
	[NGAYDAT] [datetime] NOT NULL CONSTRAINT [DF_LENHDAT_NGAYDAT]  DEFAULT (getdate()),
	[LOAIGD] [nchar](1) NOT NULL,
	[LOAILENH] [nchar](10) NOT NULL CONSTRAINT [DF_LENHDAT_LOAILENH]  DEFAULT ('LO'),
	[SOLUONG] [int] NOT NULL,
	[GIADAT] [float] NOT NULL,
	[TRANGTHAILENH] [nvarchar](30) NOT NULL CONSTRAINT [DF_LENHDAT_TRANGTHAILENH]  DEFAULT (N'Chờ khớp'),
 CONSTRAINT [PK_LENHDAT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LENHKHOP]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LENHKHOP](
	[IDKHOP] [int] IDENTITY(1,1) NOT NULL,
	[NGAYKHOP] [datetime] NOT NULL CONSTRAINT [DF_LENHKHOP_NGAYKHOP]  DEFAULT (getdate()),
	[SOLUONGKHOP] [int] NOT NULL,
	[GIAKHOP] [float] NOT NULL,
	[IDLENHDAT] [int] NOT NULL,
 CONSTRAINT [PK_LENHKHOP] PRIMARY KEY CLUSTERED 
(
	[IDKHOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[BANGGIATRUCTUYEN_LO] ([MACP], [GIAMUA1], [SOLUONGM1], [GIAMUA2], [SOLUONGM2], [GIAMUA3], [SOLUONGM3], [GIABAN1], [SOLUONGB1], [GIABAN2], [SOLUONGB2], [GIABAN3], [SOLUONGB3], [GIAKHOP], [SOLUONGKHOP], [TANGGIAMGIA], [TONGSOLUONG]) VALUES (N'ACB    ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4000, 2000, -26000, 2000)
INSERT [dbo].[BANGGIATRUCTUYEN_LO] ([MACP], [GIAMUA1], [SOLUONGM1], [GIAMUA2], [SOLUONGM2], [GIAMUA3], [SOLUONGM3], [GIABAN1], [SOLUONGB1], [GIABAN2], [SOLUONGB2], [GIABAN3], [SOLUONGB3], [GIAKHOP], [SOLUONGKHOP], [TANGGIAMGIA], [TONGSOLUONG]) VALUES (N'BIDV   ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31000, 1000, 0, 5000)
INSERT [dbo].[BANGGIATRUCTUYEN_LO] ([MACP], [GIAMUA1], [SOLUONGM1], [GIAMUA2], [SOLUONGM2], [GIAMUA3], [SOLUONGM3], [GIABAN1], [SOLUONGB1], [GIABAN2], [SOLUONGB2], [GIABAN3], [SOLUONGB3], [GIAKHOP], [SOLUONGKHOP], [TANGGIAMGIA], [TONGSOLUONG]) VALUES (N'FPT    ', 30000, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20000, 2000, 0, 4500)
INSERT [dbo].[BANGGIATRUCTUYEN_LO] ([MACP], [GIAMUA1], [SOLUONGM1], [GIAMUA2], [SOLUONGM2], [GIAMUA3], [SOLUONGM3], [GIABAN1], [SOLUONGB1], [GIABAN2], [SOLUONGB2], [GIABAN3], [SOLUONGB3], [GIAKHOP], [SOLUONGKHOP], [TANGGIAMGIA], [TONGSOLUONG]) VALUES (N'VNG    ', 9500, 2000, 9000, 1000, 0, 0, 10000, 1000, 0, 0, 0, 0, 22000, 200, 1000, 3200)
SET IDENTITY_INSERT [dbo].[LENHDAT] ON 

INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (18, N'VNG    ', CAST(N'2022-04-25 13:47:36.470' AS DateTime), N'B', N'LO        ', 0, 20000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (19, N'VNG    ', CAST(N'2022-04-25 13:47:49.950' AS DateTime), N'B', N'LO        ', 0, 21000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (23, N'VNG    ', CAST(N'2022-04-25 16:30:21.357' AS DateTime), N'B', N'LO        ', 2800, 22000, N'Khớp lệnh 1 phần')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (24, N'BIDV   ', CAST(N'2022-04-25 16:31:50.900' AS DateTime), N'B', N'LO        ', 0, 30000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (25, N'BIDV   ', CAST(N'2022-04-25 16:33:20.093' AS DateTime), N'M', N'LO        ', 0, 31000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (26, N'BIDV   ', CAST(N'2022-04-25 16:35:59.853' AS DateTime), N'M', N'LO        ', 0, 31000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (27, N'BIDV   ', CAST(N'2022-04-25 16:36:35.010' AS DateTime), N'B', N'LO        ', 0, 29000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (28, N'bidv   ', CAST(N'2022-04-25 16:40:25.443' AS DateTime), N'B', N'LO        ', 0, 10000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (29, N'BIDV   ', CAST(N'2022-04-25 16:41:35.810' AS DateTime), N'B', N'LO        ', 0, 20000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (30, N'VNG    ', CAST(N'2022-04-25 16:42:17.647' AS DateTime), N'M', N'LO        ', 0, 20500, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (31, N'VNG    ', CAST(N'2022-04-25 16:42:40.073' AS DateTime), N'M', N'LO        ', 0, 21500, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (32, N'VNG    ', CAST(N'2022-04-25 16:43:37.660' AS DateTime), N'M', N'LO        ', 0, 22500, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (33, N'VNG    ', CAST(N'2022-04-25 16:44:37.210' AS DateTime), N'M', N'LO        ', 0, 30000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (34, N'FPT    ', CAST(N'2022-04-25 16:51:35.790' AS DateTime), N'M', N'LO        ', 1000, 20000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (35, N'FPT    ', CAST(N'2022-04-25 16:52:01.657' AS DateTime), N'M', N'LO        ', 1000, 10000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (36, N'FPT    ', CAST(N'2022-04-25 16:52:16.717' AS DateTime), N'M', N'LO        ', 3000, 30000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (37, N'FPT    ', CAST(N'2022-04-25 16:52:51.280' AS DateTime), N'M', N'LO        ', 4000, 40000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (38, N'FPT    ', CAST(N'2022-04-25 16:54:03.040' AS DateTime), N'M', N'LO        ', 2000, 50000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (39, N'fpt    ', CAST(N'2022-04-26 08:23:16.147' AS DateTime), N'M', N'LO        ', 0, 50000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (40, N'fpt    ', CAST(N'2022-04-26 08:23:46.373' AS DateTime), N'B', N'LO        ', 0, 30000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (41, N'fpt    ', CAST(N'2022-04-26 08:25:31.807' AS DateTime), N'B', N'LO        ', 1000, 43000, N'Khớp lệnh 1 phần')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (42, N'FPT    ', CAST(N'2022-04-26 23:19:05.653' AS DateTime), N'M', N'LO        ', 0, 43000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (43, N'fpt    ', CAST(N'2022-04-26 23:20:29.617' AS DateTime), N'M', N'LO        ', 0, 20000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (44, N'fpt    ', CAST(N'2022-04-26 23:20:53.973' AS DateTime), N'B', N'LO        ', 500, 15000, N'Khớp lệnh 1 phần')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (45, N'ACB    ', CAST(N'2022-04-27 20:49:50.190' AS DateTime), N'M', N'LO        ', 0, 30000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (46, N'ACB    ', CAST(N'2022-04-27 20:51:33.387' AS DateTime), N'M', N'LO        ', 0, 4000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (47, N'ACB    ', CAST(N'2022-04-27 20:54:17.410' AS DateTime), N'B', N'LO        ', 0, 10000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (48, N'ACB    ', CAST(N'2022-04-27 21:06:42.980' AS DateTime), N'B', N'LO        ', 0, 2000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (49, N'VNG    ', CAST(N'2022-04-28 06:10:31.423' AS DateTime), N'B', N'LO        ', 1000, 10000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (50, N'FPT    ', CAST(N'2022-04-28 06:11:22.997' AS DateTime), N'B', N'LO        ', 0, 20000, N'Khớp hết')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (51, N'FPT    ', CAST(N'2022-04-28 06:12:14.950' AS DateTime), N'M', N'LO        ', 1000, 30000, N'Khớp lệnh 1 phần')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (52, N'VNG    ', CAST(N'2022-04-28 08:13:27.803' AS DateTime), N'M', N'LO        ', 1000, 9000, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (53, N'VNG    ', CAST(N'2022-04-28 08:13:47.650' AS DateTime), N'M', N'LO        ', 1000, 9500, N'Chờ khớp')
INSERT [dbo].[LENHDAT] ([ID], [MACP], [NGAYDAT], [LOAIGD], [LOAILENH], [SOLUONG], [GIADAT], [TRANGTHAILENH]) VALUES (54, N'VNG    ', CAST(N'2022-04-28 08:14:10.773' AS DateTime), N'M', N'LO        ', 1000, 9500, N'Chờ khớp')
SET IDENTITY_INSERT [dbo].[LENHDAT] OFF
SET IDENTITY_INSERT [dbo].[LENHKHOP] ON 

INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (11, CAST(N'2022-04-25 16:33:20.140' AS DateTime), 2000, 30000, 25)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (12, CAST(N'2022-04-25 16:33:20.140' AS DateTime), 2000, 30000, 24)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (13, CAST(N'2022-04-25 16:36:35.050' AS DateTime), 1000, 31000, 27)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (14, CAST(N'2022-04-25 16:36:35.050' AS DateTime), 1000, 31000, 25)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (15, CAST(N'2022-04-25 16:36:35.060' AS DateTime), 500, 31000, 27)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (16, CAST(N'2022-04-25 16:36:35.060' AS DateTime), 500, 31000, 26)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (17, CAST(N'2022-04-25 16:40:25.500' AS DateTime), 500, 31000, 28)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (18, CAST(N'2022-04-25 16:40:25.500' AS DateTime), 500, 31000, 26)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (19, CAST(N'2022-04-25 16:41:35.857' AS DateTime), 1000, 31000, 29)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (20, CAST(N'2022-04-25 16:41:35.857' AS DateTime), 1000, 31000, 26)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (21, CAST(N'2022-04-25 16:42:17.693' AS DateTime), 1000, 20000, 30)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (22, CAST(N'2022-04-25 16:42:17.693' AS DateTime), 1000, 20000, 18)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (23, CAST(N'2022-04-25 16:42:40.080' AS DateTime), 1500, 21000, 31)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (24, CAST(N'2022-04-25 16:42:40.080' AS DateTime), 1500, 21000, 19)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (25, CAST(N'2022-04-25 16:43:37.703' AS DateTime), 500, 21000, 32)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (26, CAST(N'2022-04-25 16:43:37.703' AS DateTime), 500, 21000, 19)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (27, CAST(N'2022-04-25 16:44:37.250' AS DateTime), 200, 22000, 33)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (28, CAST(N'2022-04-25 16:44:37.250' AS DateTime), 200, 22000, 23)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (29, CAST(N'2022-04-26 08:23:46.407' AS DateTime), 1000, 50000, 40)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (30, CAST(N'2022-04-26 08:23:46.407' AS DateTime), 1000, 50000, 39)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (31, CAST(N'2022-04-26 23:19:05.843' AS DateTime), 1000, 43000, 42)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (32, CAST(N'2022-04-26 23:19:05.843' AS DateTime), 1000, 43000, 41)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (33, CAST(N'2022-04-26 23:20:53.987' AS DateTime), 500, 20000, 44)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (34, CAST(N'2022-04-26 23:20:53.987' AS DateTime), 500, 20000, 43)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (35, CAST(N'2022-04-27 20:54:17.463' AS DateTime), 1000, 30000, 47)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (36, CAST(N'2022-04-27 20:54:17.463' AS DateTime), 1000, 30000, 45)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (37, CAST(N'2022-04-27 21:06:43.083' AS DateTime), 2000, 4000, 48)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (38, CAST(N'2022-04-27 21:06:43.083' AS DateTime), 2000, 4000, 46)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (39, CAST(N'2022-04-28 06:12:15.017' AS DateTime), 2000, 20000, 51)
INSERT [dbo].[LENHKHOP] ([IDKHOP], [NGAYKHOP], [SOLUONGKHOP], [GIAKHOP], [IDLENHDAT]) VALUES (40, CAST(N'2022-04-28 06:12:15.017' AS DateTime), 2000, 20000, 50)
SET IDENTITY_INSERT [dbo].[LENHKHOP] OFF
ALTER TABLE [dbo].[LENHKHOP]  WITH CHECK ADD  CONSTRAINT [FK_LENHKHOP_LENHDAT] FOREIGN KEY([IDLENHDAT])
REFERENCES [dbo].[LENHDAT] ([ID])
GO
ALTER TABLE [dbo].[LENHKHOP] CHECK CONSTRAINT [FK_LENHKHOP_LENHDAT]
GO
/****** Object:  Trigger [dbo].[TX_UpdateLenhDat]    Script Date: 5/12/2022 8:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TX_UpdateLenhDat]
ON [dbo].[LENHDAT]
AFTER INSERT
AS
    BEGIN
        -- Trigger Update table khi có record LENHDAT mới được thêm
        DECLARE
            @idLenhDatMB INT,
            @macp        NVARCHAR(10),
            @Ngay        NVARCHAR(10),
            @LoaiGD      CHAR,
            @soluongMB   INT,
            @giadatMB    FLOAT;
        SET @idLenhDatMB =
            (
                SELECt Inserted.ID FROM Inserted
            );
        SET @macp =
            (
				SELECT Inserted.MACP FROM Inserted
            );
        SET @Ngay =
            ( 
				SELECT CONVERT(VARCHAR(10), Inserted.NGAYDAT, 126) FROM Inserted
            );
        SET @LoaiGD =
            (
				SELECT Inserted.LOAIGD FROM Inserted
            );
        SET @soluongMB =
            (
                SELECT Inserted.SOLUONG FROM Inserted
            );
        SET @giadatMB =
            (
                SELECT Inserted.GIADAt FROM Inserted
            );

		if not exists(select 1 from dbo.BANGGIATRUCTUYEN_LO where MACP = @macp)
		insert into dbo.BANGGIATRUCTUYEN_LO(MACP) values (@macp) 

        EXEC SP_KHOPLENH_LO
            @idLenhDatMB,
            @macp,
            @Ngay,
            @LoaiGD,
            @soluongMB,
            @giadatMB;
    END;

GO
USE [master]
GO
ALTER DATABASE [CHUNGKHOAN] SET  READ_WRITE 
GO
