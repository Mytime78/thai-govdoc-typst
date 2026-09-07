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

  // TH Sarabun New 16pt (ระยะบรรทัดปกติ 1 เท่า หรือ Single)[cite: 5]
  set text(
    font: ("TH Sarabun New", "THSarabunNew"),
    size: 16pt,
    lang: "th",
    region: "TH"
  )

  set par(justify: true, leading: 0.58em)

  // ชั้นความเร็ว และ ชั้นความลับ (ตัวหนา 32pt สีแดง)[cite: 5]
  if urgency != "" {
    place(top + left, dx: 0cm, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#urgency])
  }
  if secrecy != "" {
    place(top + center, dy: 0cm, text(fill: red, size: 32pt, weight: "bold")[#secrecy])
  }

  // 1. ตราครุฑ 3 ซม. กึ่งกลางหน้ากระดาษ[cite: 5]
  align(center)[
    #image("garuda.svg", height: 3cm)
  ]

  v(-1.25cm)

  // 2. แถว "ที่" ชิดซ้าย และ "ส่วนราชการ" เคาะขวา 2 เคาะ -> 10.5cm[cite: 5]
  grid(
    columns: (10.5cm, 1fr),
    [ที่ #h(0.4em) #thnum(id)],
    [
      #set par(leading: 0.45em)
      #origin
    ]
  )

  v(6pt) // Enter + Before 6 pt[cite: 5]

  // 3. วัน เดือน ปี (8.0cm)[cite: 5]
  grid(
    columns: (8.0cm, 1fr),
    [],
    [#thnum(day) #h(0.5em) #thnum(month) #h(0.5em) #thnum(year)]
  )

  v(6pt) // Enter + Before 6 pt[cite: 5]

  // 4. แถว เรื่อง, เรียน, อ้างถึง, สิ่งที่ส่งมาด้วย (เว้น ๒ เคาะ)[cite: 5]
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
    row-gutter: 6pt + 0.58em,
    column-gutter: 0.3em,
    ..header_rows
  )

  v(6pt) // Enter + Before 6 pt[cite: 5]

  // 5. เนื้อหาหนังสือ
  body

  v(12pt) // ก่อนคำลงท้าย Enter + Before 12 pt[cite: 5]

  // 6. คำลงท้าย และ ลายมือชื่อ
  // คำลงท้ายอยู่ที่ 8.0cm
  // กลุ่มชื่อผู้ลงนามจัดกึ่งกลางเทียบกับแนวคำลงท้าย (ความกว้างคำลงท้าย ~3.6cm ศูนย์กลางอยู่ที่ 8.0cm + 1.8cm)
  grid(
    columns: (8.0cm, 1fr),
    [],
    [
      #signoff
      #v(2.0cm) // พื้นที่ 4 Enter สำหรับลงลายมือชื่อ[cite: 5]
      #place(dx: 1.8cm)[
        #align(center)[
          #box(width: 10cm)[
            #signer_name \
            #v(2pt)
            #signer_pos
          ]
        ]
      ]
    ]
  )

  v(1fr)

  // 7. ส่วนราชการเจ้าของเรื่อง ชิดขอบล่างซ้าย[cite: 5]
  set par(first-line-indent: 0cm, leading: 0.45em)
  contact
}
