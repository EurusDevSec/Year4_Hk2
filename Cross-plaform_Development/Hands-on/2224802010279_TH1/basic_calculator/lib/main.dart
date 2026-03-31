import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _hienThi = '0'; // Giá trị đang hiển thị trên màn hình
  String _soTruoc = ''; // Số thứ nhất (trước khi bấm phép tính)
  String _phepTinh = ''; // Phép tính đang chọn: +, -, ×, ÷
  bool _chuanBiNhapSoMoi =
      false; // true = sẵn sàng nhập số mới (sau khi bấm phép tính)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '2224802010279-Le Van Hoang',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _xayDungManHinh()),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: _xayDungNutBam(),
          ),
        ],
      ),
    );
  }

  Widget _xayDungManHinh() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      alignment: Alignment.centerRight,
      child: Text(
        _hienThi,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 64,
          fontWeight: FontWeight.w300,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _xayDungNutBam() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _taoNut(nhanNut: '0'),
                _taoNut(nhanNut: 'C'),
                _taoNut(nhanNut: ','),
                _taoNut(nhanNut: '⌫'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _taoNut(nhanNut: '7'),
                _taoNut(nhanNut: '8'),
                _taoNut(nhanNut: '9'),
                _taoNut(nhanNut: '÷'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _taoNut(nhanNut: '4'),
                _taoNut(nhanNut: '5'),
                _taoNut(nhanNut: '6'),
                _taoNut(nhanNut: '×'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _taoNut(nhanNut: '1'),
                _taoNut(nhanNut: '2'),
                _taoNut(nhanNut: '3'),
                _taoNut(nhanNut: '-'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _taoNut(nhanNut: '=', mauNen: Colors.lightBlue, soLuongCot: 3),
                _taoNut(nhanNut: '+'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _taoNut({
    required String nhanNut,
    Color mauNen = const Color(0xFF333333),
    Color mauChu = Colors.white,
    int soLuongCot = 1,
  }) {
    return Expanded(
      flex: soLuongCot,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox.expand(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mauNen,
              foregroundColor: mauChu,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _xuLyNutBam(nhanNut),
            child: Text(
              nhanNut,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _xuLyNutBam(String nhanNut) {
    setState(() {
      if (nhanNut == 'C') {
        _hienThi = '0';
        _soTruoc = '';
        _phepTinh = '';
        _chuanBiNhapSoMoi = false;
      } else if (nhanNut == '⌫') {
        if (_hienThi.length > 1) {
          _hienThi = _hienThi.substring(0, _hienThi.length - 1);
        } else {
          _hienThi = '0';
        }
      } else if (nhanNut == '+' ||
          nhanNut == '-' ||
          nhanNut == '×' ||
          nhanNut == '÷') {
        _soTruoc = _hienThi;
        _phepTinh = nhanNut;
        _chuanBiNhapSoMoi = true;
      } else if (nhanNut == '=') {
        if (_soTruoc.isNotEmpty && _phepTinh.isNotEmpty) {
          double soThuNhat = double.parse(_soTruoc);
          double soThuHai = double.parse(_hienThi);
          double ketQua = _thucHienPhepTinh(soThuNhat, soThuHai, _phepTinh);
          if (ketQua == ketQua.truncateToDouble()) {
            _hienThi = ketQua.toInt().toString();
          } else {
            _hienThi = ketQua.toString();
          }
          _soTruoc = '';
          _phepTinh = '';
          _chuanBiNhapSoMoi = false;
        }
      } else if (nhanNut == ',') {
        if (!_hienThi.contains('.')) {
          _hienThi = '$_hienThi.';
        }
      } else {
        if (_hienThi == '0' || _chuanBiNhapSoMoi) {
          _hienThi = nhanNut;
          _chuanBiNhapSoMoi = false;
        } else {
          _hienThi = _hienThi + nhanNut;
        }
      }
    });
  }

  double _thucHienPhepTinh(double soThuNhat, double soThuHai, String phepTinh) {
    switch (phepTinh) {
      case '+':
        return soThuNhat + soThuHai;
      case '-':
        return soThuNhat - soThuHai;
      case '×':
        return soThuNhat * soThuHai;
      case '÷':
        if (soThuHai == 0) {
          _hienThi = 'Lỗi';
          return 0;
        }
        return soThuNhat / soThuHai;
      default:
        return soThuHai;
    }
  }
}
