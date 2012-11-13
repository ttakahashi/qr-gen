require 'csv'

HTML_NAME = "output_" # �o��HTML�t�@�C����
CSV_NAME = "file_" # ����CSV�t�@�C����
URL = "URL"
TUPLE = 5 # �c�̗�
MAX_FILE = 2 # ���v�o�̓t�@�C����
QR = 20 # �\���Ƃ�QR�R�[�h�̐�

count = 1
line = []
file = 1
index = {:aka_atari => 1, :aka_hazure => 1, :ao_atari => 1, :ao_hazure => 1, :midori_atari => 1, :midori_hazure => 1}

while file <= MAX_FILE do	#�t�@�C���̐�
  p "file:#{file}"
  #qrcode_senpo1.html��ǉ��������݃��[�h�ŃI�[�v��
  fwname = HTML_NAME + "%01d.html" % file
  File.unlink(fwname) if File.exist?(fwname)
  fw = File.open(fwname, "a")
  #�w�b�_��������
  fw.puts('<html><head><style>.serial{padding:2px;}.number{padding:2px;}.number{page-break-before:always;}</style></head><body>')
  fw.close
  while count <= 6 do	#�\�̐�
    p "count:#{count}"
    case count
      when 1 then
        midashi = '<font color="red"><h2>�Ԃ�����</h2></font>'
        fno_r = 1
        cell = QR*file
        subtotal = index[:aka_atari]
        line.slice!(0,30000)
      when 2 then
        midashi = '<font color="red"><h2>�Ԃ͂���</h2></font>'
        fno_r = 4
        cell = QR*file
        subtotal = index[:aka_hazure]
        line.slice!(0,30000)
      when 3 then
        midashi = '<font color="blue"><h2>������</h2></font>'
        fno_r = 2
        cell = QR*file
        subtotal = index[:ao_atari]
        line.slice!(0,30000)
      when 4 then
        midashi = '<font color="blue"><h2>�͂���</h2></font>'
        fno_r = 5
        cell = QR*file
        subtotal = index[:ao_hazure]
        line.slice!(0,30000)
      when 5 then
        midashi = '<font color="green"><h2>�΂�����</h2></font>'
        fno_r = 3
        cell = QR*file
        subtotal = index[:midori_atari]
        line.slice!(0,30000)
      when 6 then
        midashi = '<font color="green"><h2>�΂͂���</h2></font>'
        fno_r = 6
        cell = QR*file
        subtotal = index[:midori_hazure]
        line.slice!(0,30000)
      else
        p '"count" become worng number'
    end
    
  fwname = HTML_NAME + "%01d.html" % file
  fw = File.open(fwname, "a")
    fw.puts(midashi)
#�e�[�u���錾
    fw.puts('<table border="3" cellpadding="5"><tbody>')

#CSV��z��ɓǍ�
    CSV.open(CSV_NAME + "%02d.csv" % fno_r, 'r', "\t") do |lines|
    line << lines[0]
    end
    
#�z�񂩂�l��ǂݍ����URL������������
    set = 1
    while subtotal <= cell do
      serial = line[subtotal-1].strip
      url = 'http://chart.apis.google.com/chart?chs=130x130&cht=qr&chl=' + URL + serial
  
#5�Ŋ����Ă݂ĂP�]������tr�}��
      fw.puts('<tr>') if set.modulo(TUPLE) == 1

#�Z���}��
      fw.puts("<td><div class='number'>#{subtotal}</div><div class='qr'><img src='#{url}' /></div><div class='serial'>#{serial}</div></td>")

#�T�Ŋ���؂ꂽ��tr��؂�}��
      fw.puts('</tr>') if set.modulo(TUPLE) == 0

#�Ō��
      subtotal += 1
      set += 1
    end	#cell�񃋁[�v
    fw.puts('</table>')
    case count
      when 1 then
        index[:aka_atari] = subtotal
        fw.close
      when 2 then
        index[:aka_hazure] = subtotal
        fw.close
      when 3 then
        index[:ao_atari] = subtotal
        fw.close
      when 4 then
        index[:ao_hazure] = subtotal
        fw.close
      when 5 then
        index[:midori_atari] = subtotal
        fw.close
      when 6 then
        index[:midori_hazure] = subtotal
        fw.puts('</body></html>')	#����
        fw.close
      else
        p '"count" become worng number'
    end

    count += 1
  end	#�\�̍쐬
  count = 1
  file += 1

end #�t�@�C���̍쐬
