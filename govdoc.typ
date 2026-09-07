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
  month: "",
  year: "",
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
  // ขอบกระดาษ A4: บน 1.5 ซม. ล่าง 2 ซม. ซ้าย 3 ซม. ขวา 2 ซม.
  set page(
    paper: "a4",
    margin: (top: 1.5cm, bottom: 2cm, left: 3cm, right: 2cm)
  )

  // TH Sarabun New 16pt
  set text(
    font: ("TH Sarabun New", "THSarabunNew"),
    size: 16pt,
    lang: "th",
    region: "TH"
  )

  set par(justify: true, leading: 0.58em)

  // ชั้นความเร็ว และ ชั้นความลับ
  if urgency != "" {
    place(top + left, dx: 0cm, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#urgency])
  }
  if secrecy != "" {
    place(top + center, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#secrecy])
  }

  // 1. ตราครุฑ 3 ซม. กึ่งกลางหน้ากระดาษ
  align(center)[
    #image("garuda.svg", height: 3cm)
  ]

  // เว้นระยะให้บรรทัด "ที่" ตรงกับระดับปลายเท้าล่างสุดของครุฑ (เขียน v() โดยไม่ต้องมี #)
  v(0.25cm)

  // 2. แถว "ที่" ชิดซ้าย และ "ส่วนราชการ" ขยับไปเริ่มที่ระยะ 10.2 ซม. (โปร่งตามตัวอย่าง อย.)
  grid(
    columns: (10.2cm, 1fr),
    [ที่ #h(0.4em) #thnum(id)],
    [
      #set par(leading: 0.45em)
      #origin
    ]
  )

  v(10pt) // Enter + Before 6 pt

  // 3. วัน เดือน ปี (เกาะเส้นกึ่งกลางหน้ากระดาษ 7.5 ซม.)
  grid(
    columns: (7.5cm, 1fr),
    [],
    [#thnum(day) #h(0.5em) #thnum(month) #h(0.5em) #thnum(year)]
  )

  v(10pt) // Enter + Before 6 pt

  // 4. แถว เรื่อง, เรียน, อ้างถึง, สิ่งที่ส่งมาด้วย
  let header_rows = (
    [เรื่อง #h(0.4em)], [#title],
    [เรียน #h(0.4em)], [#to],
  )
  if ref != "" {
    header_rows.push([อ้างถึง #h(0.4em)])
    header_rows.push([#ref])
  }
  if attachment != "" {
    header_rows.push([สิ่งที่ส่งมาด้วย #h(0.4em)])
    header_rows.push([#attachment])
  }

  grid(
    columns: (auto, 1fr),
    row-gutter: 8pt + 0.58em,
    column-gutter: 0.3em,
    ..header_rows
  )

  v(10pt) // Enter + Before 6 pt

  // 5. เนื้อหาหนังสือ
  body

  v(14pt) // ก่อนคำลงท้าย Enter + Before 12 pt

  // 6. คำลงท้าย และ ลายมือชื่อ
  grid(
    columns: (7.5cm, 1fr),
    [],
    [
      #align(left)[#signoff]
      #v(2.0cm)
      #box(width: 100%, align(center)[
        #signer_name \
        #v(2pt)
        #signer_pos
      ])
    ]
  )

  v(1fr)

  // 7. ส่วนราชการเจ้าของเรื่อง
  set par(first-line-indent: 0cm, leading: 0.45em)
  contact
}
