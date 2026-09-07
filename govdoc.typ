// ฟังก์ชันแปลงเลขอารบิกเป็นเลขไทย
#let thnum(num) = {
  if type(num) == str or type(num) == int or type(num) == float {
    str(num)
      .replace("0", "๐")
      .replace("1", "๑")
      .replace("2", "๒")
      .replace("3", "๓")
      .replace("4", "๔")
      .replace("5", "๕")
      .replace("6", "๖")
      .replace("7", "๗")
      .replace("8", "๘")
      .replace("9", "๙")
  } else {
    num
  }
}

#let letter(
  urgency: "",
  secrecy: "",
  id: "",
  origin: [],
  day: "",
  month_year: "",
  title: "",
  to: "",
  ref: "",
  attachment: "",
  signoff: "ขอแสดงความนับถือ",
  signer_name: "",
  signer_pos: "",
  contact: [],
  body
) = {
  // หน้ากระดาษ A4: บน 1.5 ซม. ล่าง 2 ซม. ซ้าย 3 ซม. ขวา 2 ซม.
  set page(
    paper: "a4",
    margin: (top: 1.5cm, bottom: 2cm, left: 3cm, right: 2cm)
  )

  // ฟอนต์ TH Sarabun New ขนาด 16pt
  set text(
    font: ("TH Sarabun New", "THSarabunNew"),
    size: 16pt,
    lang: "th",
    region: "TH"
  )

  set par(justify: true, leading: 0.58em)

  // ชั้นความเร็ว และ ชั้นความลับ (ตัวหนา 32pt สีแดง)
  if urgency != "" {
    place(top + left, dx: 0cm, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#urgency])
  }
  if secrecy != "" {
    place(top + center, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#secrecy])
  }

  // ครุฑ สูง 3 ซม. วางกึ่งกลางหน้ากระดาษ
  align(center)[
    #image("garuda.svg", height: 3cm)
  ]

  // แถว "ที่" ชิดซ้าย และ "ส่วนราชการ" วางขวา
  grid(
    columns: (7.5cm, 1fr),
    gutter: 0.5cm,
    [ที่ #h(0.4em) #thnum(id)],
    [
      #set par(leading: 0.45em)
      #origin
    ]
  )

  v(6pt) // 1 Enter + Before 6pt

  // วัน เดือน ปี: เริ่มต้นตรงเส้นแกนกึ่งกลางหน้ากระดาษ (7.5cm) พอดีเป๊ะตามภาพที่ 2
  grid(
    columns: (7.5cm, 1fr),
    [],
    [#thnum(day) #h(0.6em) #thnum(month_year)]
  )

  v(6pt) // 1 Enter + Before 6pt

  // แถว เรื่อง, เรียน, อ้างถึง, สิ่งที่ส่งมาด้วย (เว้น ๒ เคาะ)
  let rows = (
    [เรื่อง #h(0.4em)], [#title],
    [เรียน #h(0.4em)], [#to],
  )
  if ref != "" {
    rows.push([อ้างถึง #h(0.4em)])
    rows.push([#ref])
  }
  if attachment != "" {
    rows.push([สิ่งที่ส่งมาด้วย #h(0.4em)])
    rows.push([#attachment])
  }

  grid(
    columns: (auto, 1fr),
    row-gutter: 6pt + 0.58em,
    column-gutter: 0.3em,
    ..rows
  )

  v(6pt) // 1 Enter + Before 6pt

  // ข้อความเนื้อหา (ร่นย่อหน้า 2.5 ซม.)
  set par(first-line-indent: 2.5cm)
  body

  v(12pt) // 1 Enter + Before 12pt ก่อนคำลงท้าย

  // คำลงท้าย และ ลายมือชื่อ: ตัวอักษรตัวแรกเริ่มตรงเส้นแกนกึ่งกลาง (7.5cm) พอดีเป๊ะ
  grid(
    columns: (7.5cm, 1fr),
    [],
    [
      #align(left)[#signoff]
      #v(1.8cm) // ระยะ 4 Enter สำหรับลงลายมือชื่อ
      #align(center)[
        (#signer_name) \
        #v(2pt)
        #signer_pos
      ]
    ]
  )

  v(1fr)

  // ส่วนราชการเจ้าของเรื่อง ชิดขอบล่างซ้าย
  set par(first-line-indent: 0cm, leading: 0.45em)
  contact
}
