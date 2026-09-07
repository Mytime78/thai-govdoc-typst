// ฟังก์ชันแปลงเลขอารบิกเป็นเลขไทย
#let thnum(num) = str(num)
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

// เทมเพลตหลักสำหรับหนังสือภายนอก
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
  // ตั้งค่าหน้ากระดาษตามระเบียบงานสารบรรณ
  set page(
    paper: "a4",
    margin: (top: 1.5cm, bottom: 2cm, left: 3cm, right: 2cm)
  )

  // กำหนดฟอนต์ TH Sarabun New
  set text(
    font: ("TH Sarabun New", "THSarabunNew"),
    size: 16pt,
    lang: "th",
    region: "TH"
  )

  // ระยะบรรทัดปกติ
  set par(justify: true, leading: 0.55em)

  // ชั้นความเร็ว และ ชั้นความลับ
  if urgency != "" {
    place(top + left, dx: 0cm, dy: 0cm, text(red, 18pt, weight: "bold")[#urgency])
  }
  if secrecy != "" {
    place(top + center, dy: 0cm, text(red, 18pt, weight: "bold")[#secrecy])
  }

  // 1. ตราครุฑ 3 ซม. กึ่งกลางหน้ากระดาษ
  align(center)[
    #image("garuda.svg", height: 3cm)
  ]

  // 2. แถว "ที่" และ "ส่วนราชการ" (ตรงแนวเท้าครุฑ)
  grid(
    columns: (7.5cm, 1fr),
    gutter: 0.5cm,
    [ที่  #thnum(id)],
    [#set par(leading: 0.4em); #origin]
  )

  v(6pt) // Enter + Before 6pt

  // 3. วันที่ (ชื่อเดือนอยู่ตรงกับแนวเท้าขวาของตราครุฑ)
  place(dx: 7.5cm - 2.8em)[#thnum(day)]
  place(dx: 7.5cm)[#thnum(month_year)]
  v(16pt)

  v(6pt) // Enter + Before 6pt

  // 4. แถว เรื่อง, เรียน, อ้างถึง, สิ่งที่ส่งมาด้วย
  let rows = (
    [เรื่อง], [#title],
    [เรียน], [#to],
  )
  if ref != "" {
    rows.push([อ้างถึง])
    rows.push([#ref])
  }
  if attachment != "" {
    rows.push([สิ่งที่ส่งมาด้วย])
    rows.push([#attachment])
  }

  grid(
    columns: (2.5cm, 1fr),
    row-gutter: 6pt + 0.55em,
    ..rows
  )

  v(6pt) // Enter + Before 6pt

  // 5. เนื้อหา ย่อหน้า 2.5 ซม.
  set par(first-line-indent: 2.5cm)
  body

  v(12pt) // ก่อนคำลงท้าย Enter + Before 12pt

  // 6. คำลงท้าย และ ลายมือชื่อ (กึ่งกลางหน้ากระดาษ)
  grid(
    columns: (7.5cm, 1fr),
    [],
    [
      #align(left)[#signoff]
      #v(2.0cm) // เว้นสำหรับลงลายมือชื่อ
      #align(center)[
        (#signer_name) \
        #v(0.1cm)
        #signer_pos
      ]
    ]
  )

  v(1fr)

  // 7. ส่วนราชการเจ้าของเรื่อง ชิดขอบล่างซ้าย
  set par(leading: 0.4em)
  contact
}
