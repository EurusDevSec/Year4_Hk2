import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Calculator',
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
  String _hienThi = '0';
  String _soTruoc = '';
  String _phepTinh = '';
  bool _chuanBiNhapSoMoi = false;

  // Bộ nhớ
  double _boNho = 0;

  // Lịch sử tính toán
  final List<String> _lichSu = [];

  // ── helpers
  String _formatKetQua(double v) {
    if (v.isNaN || v.isInfinite) return 'Lỗi';
    return v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
  }

  double get _giaTriHienThi {
    if (_hienThi == 'Lỗi') return 0;
    return double.tryParse(_hienThi) ?? 0;
  }

  // ── build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '222480210279-Le Van Hoang',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Lịch sử',
            onPressed: _moLichSu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _xayDungManHinh()),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: _xayDungNutBam(),
          ),
        ],
      ),
    );
  }

  // ── Màn hình
  Widget _xayDungManHinh() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Biểu thức đang tính
          if (_soTruoc.isNotEmpty && _phepTinh.isNotEmpty)
            Text(
              '$_soTruoc $_phepTinh',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          // Giá trị hiện tại
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _hienThi,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          // Chỉ báo bộ nhớ
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _boNho != 0 ? 'M = ${_formatKetQua(_boNho)}' : '',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bàn phím
  Widget _xayDungNutBam() {
    const mauNhom1 = Color(0xFF444444); // Bộ nhớ
    const mauNhom2 = Color(0xFF555555); // Chức năng
    const mauPhepTinh = Color(0xFF666666); // Phép tính
    const mauSo = Color(0xFF333333); // Số
    const mauBang = Colors.lightBlue; // =

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Column(
        children: [
          // Hàng 1: M+  M-  MS
          Expanded(
            child: Row(
              children: [
                _taoNut(label: 'M+', mauNen: mauNhom1),
                _taoNut(label: 'M-', mauNen: mauNhom1),
                _taoNut(label: 'MS', mauNen: mauNhom1),
              ],
            ),
          ),
          // Hàng 2: %  CE  C  ⌫
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '%', mauNen: mauNhom2),
                _taoNut(label: 'CE', mauNen: mauNhom2),
                _taoNut(label: 'C', mauNen: mauNhom2),
                _taoNut(label: '⌫', mauNen: mauNhom2),
              ],
            ),
          ),
          // Hàng 3: 1/x  x²  √x  ÷
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '¹/x', mauNen: mauNhom2),
                _taoNut(label: 'x²', mauNen: mauNhom2),
                _taoNut(label: '√x', mauNen: mauNhom2),
                _taoNut(label: '÷', mauNen: mauPhepTinh),
              ],
            ),
          ),
          // Hàng 4: 7  8  9  ×
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '7', mauNen: mauSo),
                _taoNut(label: '8', mauNen: mauSo),
                _taoNut(label: '9', mauNen: mauSo),
                _taoNut(label: '×', mauNen: mauPhepTinh),
              ],
            ),
          ),
          // Hàng 5: 4  5  6  -
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '4', mauNen: mauSo),
                _taoNut(label: '5', mauNen: mauSo),
                _taoNut(label: '6', mauNen: mauSo),
                _taoNut(label: '-', mauNen: mauPhepTinh),
              ],
            ),
          ),
          // Hàng 6: 1  2  3  +
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '1', mauNen: mauSo),
                _taoNut(label: '2', mauNen: mauSo),
                _taoNut(label: '3', mauNen: mauSo),
                _taoNut(label: '+', mauNen: mauPhepTinh),
              ],
            ),
          ),
          // Hàng 7: +/-  0  ,  =
          Expanded(
            child: Row(
              children: [
                _taoNut(label: '+/-', mauNen: mauSo),
                _taoNut(label: '0', mauNen: mauSo),
                _taoNut(label: ',', mauNen: mauSo),
                _taoNut(label: '=', mauNen: mauBang),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _taoNut({
    required String label,
    Color mauNen = const Color(0xFF333333),
    Color mauChu = Colors.white,
  }) {
    return Expanded(
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
            onPressed: () => _xuLyNutBam(label),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Xử lý nút bấm
  void _xuLyNutBam(String nhan) {
    setState(() {
      switch (nhan) {
        // ── Xóa
        case 'C':
          _hienThi = '0';
          _soTruoc = '';
          _phepTinh = '';
          _chuanBiNhapSoMoi = false;
          break;

        case 'CE':
          // Chỉ xóa số đang nhập, giữ phép tính
          _hienThi = '0';
          _chuanBiNhapSoMoi = false;
          break;

        case '⌫':
          if (_hienThi == 'Lỗi') {
            _hienThi = '0';
          } else if (_hienThi.length > 1) {
            _hienThi = _hienThi.substring(0, _hienThi.length - 1);
          } else {
            _hienThi = '0';
          }
          break;

        // ── Bộ nhớ
        case 'MS':
          _boNho = _giaTriHienThi;
          break;

        case 'M+':
          _boNho += _giaTriHienThi;
          break;

        case 'M-':
          _boNho -= _giaTriHienThi;
          break;

        // ── Phép tính 1 toán hạng
        case '%':
          // % của số trước (nếu có), hoặc /100
          if (_soTruoc.isNotEmpty && _phepTinh.isNotEmpty) {
            final base = double.tryParse(_soTruoc) ?? 0;
            _hienThi = _formatKetQua(base * _giaTriHienThi / 100);
          } else {
            _hienThi = _formatKetQua(_giaTriHienThi / 100);
          }
          _chuanBiNhapSoMoi = true;
          break;

        case '¹/x':
          if (_giaTriHienThi == 0) {
            _hienThi = 'Lỗi';
          } else {
            _hienThi = _formatKetQua(1 / _giaTriHienThi);
          }
          _chuanBiNhapSoMoi = true;
          break;

        case 'x²':
          _hienThi = _formatKetQua(pow(_giaTriHienThi, 2).toDouble());
          _chuanBiNhapSoMoi = true;
          break;

        case '√x':
          if (_giaTriHienThi < 0) {
            _hienThi = 'Lỗi';
          } else {
            _hienThi = _formatKetQua(sqrt(_giaTriHienThi));
          }
          _chuanBiNhapSoMoi = true;
          break;

        case '+/-':
          if (_hienThi != '0' && _hienThi != 'Lỗi') {
            if (_hienThi.startsWith('-')) {
              _hienThi = _hienThi.substring(1);
            } else {
              _hienThi = '-$_hienThi';
            }
          }
          break;

        // ── Phép tính 2 toán hạng
        case '+':
        case '-':
        case '×':
        case '÷':
          // Nếu đã có phép tính chưa hoàn thành → tính ngay
          if (_soTruoc.isNotEmpty &&
              _phepTinh.isNotEmpty &&
              !_chuanBiNhapSoMoi) {
            final kq = _thucHienPhepTinh(
              double.parse(_soTruoc),
              _giaTriHienThi,
              _phepTinh,
            );
            _hienThi = _formatKetQua(kq);
          }
          _soTruoc = _hienThi;
          _phepTinh = nhan;
          _chuanBiNhapSoMoi = true;
          break;

        case '=':
          if (_soTruoc.isNotEmpty && _phepTinh.isNotEmpty) {
            final soThuNhat = double.parse(_soTruoc);
            final soThuHai = _giaTriHienThi;
            final ketQua = _thucHienPhepTinh(soThuNhat, soThuHai, _phepTinh);
            final ketQuaStr = _formatKetQua(ketQua);

            // Lưu lịch sử
            _lichSu.insert(0, '$_soTruoc $_phepTinh $soThuHai = $ketQuaStr');

            _hienThi = ketQuaStr;
            _soTruoc = '';
            _phepTinh = '';
            _chuanBiNhapSoMoi = true;
          }
          break;

        // ── Dấu thập phân
        case ',':
          if (_chuanBiNhapSoMoi) {
            _hienThi = '0.';
            _chuanBiNhapSoMoi = false;
          } else if (!_hienThi.contains('.')) {
            _hienThi = '$_hienThi.';
          }
          break;

        // ── Chữ số
        default:
          if (_hienThi == 'Lỗi' || _hienThi == '0' || _chuanBiNhapSoMoi) {
            _hienThi = nhan;
            _chuanBiNhapSoMoi = false;
          } else {
            _hienThi = _hienThi + nhan;
          }
      }
    });
  }

  double _thucHienPhepTinh(double a, double b, String phep) {
    switch (phep) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) return double.nan;
        return a / b;
      default:
        return b;
    }
  }

  // ── Lịch sử
  void _moLichSu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lịch sử tính toán',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_lichSu.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() => _lichSu.clear());
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Xóa tất cả',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 1),
            Expanded(
              child: _lichSu.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có lịch sử',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _lichSu.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Color(0xFF333333), height: 1),
                      itemBuilder: (_, i) => ListTile(
                        title: Text(
                          _lichSu[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        onTap: () {
                          // Tap để dùng lại kết quả
                          final parts = _lichSu[i].split(' = ');
                          if (parts.length == 2) {
                            setState(() {
                              _hienThi = parts[1];
                              _chuanBiNhapSoMoi = true;
                            });
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
