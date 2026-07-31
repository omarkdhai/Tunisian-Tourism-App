-- Seed data: real Tunisian tourist places
INSERT INTO places (name, name_ar, description, description_ar, category, latitude, longitude, address, governorate, opening_hours, entrance_price, estimated_visit_duration, best_time_to_visit, family_friendly, solo_friendly) VALUES

-- Beaches
('Sidi Bou Said Beach', 'شاطئ سيدي بو سعيد', 'A stunning Mediterranean beach beneath the iconic blue-and-white village of Sidi Bou Said. Crystal clear waters and beautiful cliffside views.', 'شاطئ متوسطي خلاب تحت قرية سيدي بو سعيد الشهيرة بألوانها الزرقاء والبيضاء', 'BEACH', 36.8687, 10.3477, 'Sidi Bou Said, Tunis', 'Tunis', 'Open 24/7', 0, 180, 'June to September', true, true),
('Hammamet Beach', 'شاطئ الحمامات', 'One of Tunisia''s most famous resort beaches with golden sand stretching for kilometers along the Mediterranean coast.', 'من أشهر شواطئ تونس السياحية برمال ذهبية تمتد لكيلومترات', 'BEACH', 36.4000, 10.6167, 'Hammamet', 'Nabeul', 'Open 24/7', 0, 240, 'May to October', true, true),
('Djerba Beach', 'شاطئ جربة', 'Beautiful island beaches with white sand and turquoise waters on the island of Djerba.', 'شواطئ جزيرة جربة الجميلة برمال بيضاء ومياه فيروزية', 'BEACH', 33.8076, 10.8578, 'Djerba Island', 'Medenine', 'Open 24/7', 0, 300, 'May to October', true, true),

-- Monuments
('Carthage Ruins', 'آثار قرطاج', 'UNESCO World Heritage Site - the legendary ancient city of Carthage, founded by Phoenicians in 814 BC. Includes the Antonine Baths, Byrsa Hill, and ancient ports.', 'موقع تراث عالمي لليونسكو - مدينة قرطاج الأسطورية التي أسسها الفينيقيون عام 814 قبل الميلاد', 'MONUMENT', 36.8528, 10.3233, 'Carthage, Tunis', 'Tunis', '08:00-19:00', 12, 150, 'March to May, September to November', true, true),
('El Jem Amphitheatre', 'مدرج الجم', 'UNESCO World Heritage Site - one of the best-preserved Roman amphitheatres in the world, built around 238 AD. Capacity of 35,000 spectators.', 'موقع تراث عالمي لليونسكو - من أفضل المدرجات الرومانية المحفوظة في العالم', 'MONUMENT', 35.2961, 10.7069, 'El Jem, Mahdia', 'Mahdia', '07:30-19:00', 14, 120, 'March to May', true, true),
('Bardo Museum', 'متحف باردو', 'One of the most important museums in the Mediterranean region, housing the world''s largest collection of Roman mosaics.', 'من أهم المتاحف في منطقة البحر الأبيض المتوسط يضم أكبر مجموعة فسيفساء رومانية', 'MONUMENT', 36.8094, 10.1344, 'Le Bardo, Tunis', 'Tunis', '09:00-17:00', 13, 120, 'Year-round', true, true),
('Dougga', 'دقة', 'UNESCO World Heritage Site - the best-preserved Roman town in North Africa with a stunning hilltop setting.', 'موقع تراث عالمي لليونسكو - أفضل مدينة رومانية محفوظة في شمال أفريقيا', 'MONUMENT', 36.4225, 9.2194, 'Dougga, Beja', 'Beja', '08:00-18:00', 8, 150, 'March to May, September to November', true, true),

-- Culture
('Medina of Tunis', 'المدينة العتيقة بتونس', 'UNESCO World Heritage Site - the historic heart of Tunis with narrow souks, mosques, and traditional architecture dating back to the 7th century.', 'موقع تراث عالمي لليونسكو - القلب التاريخي لتونس بأسواقها ومساجدها وعمارتها التقليدية', 'CULTURE', 36.7992, 10.1706, 'Medina, Tunis', 'Tunis', '08:00-20:00', 0, 180, 'Year-round', true, true),
('Sidi Bou Said Village', 'قرية سيدي بو سعيد', 'Iconic blue-and-white hilltop village overlooking the Gulf of Tunis. Famous for its bohemian atmosphere, art galleries, and Café des Nattes.', 'قرية مميزة بألوانها الزرقاء والبيضاء تطل على خليج تونس', 'CULTURE', 36.8702, 10.3475, 'Sidi Bou Said', 'Tunis', 'Open 24/7', 0, 120, 'Year-round', true, true),
('Kairouan Great Mosque', 'الجامع الأعظم بالقيروان', 'UNESCO World Heritage Site - one of the oldest and most important mosques in North Africa, founded in 670 AD.', 'موقع تراث عالمي لليونسكو - من أقدم وأهم المساجد في شمال أفريقيا', 'CULTURE', 35.6812, 10.1034, 'Kairouan', 'Kairouan', '08:00-14:00', 0, 60, 'Year-round', true, true),

-- Food
('Dar El Jeld', 'دار الجلد', 'Prestigious Tunisian restaurant in a restored 18th-century palace in the Medina of Tunis. Traditional Tunisian fine dining experience.', 'مطعم تونسي راقي في قصر مرمم من القرن الثامن عشر في المدينة العتيقة', 'FOOD', 36.7986, 10.1702, '5-10 Rue Dar el Jeld, Tunis', 'Tunis', '12:00-15:00, 19:00-23:00', 0, 120, 'Year-round', true, true),
('Central Market Tunis', 'السوق المركزي تونس', 'Vibrant central market where locals shop for fresh produce, fish, spices, and olives. A true sensory experience of Tunisian daily life.', 'سوق مركزي نابض بالحياة لشراء المنتجات الطازجة والأسماك والتوابل', 'FOOD', 36.7961, 10.1756, 'Rue Charles de Gaulle, Tunis', 'Tunis', '06:00-14:00', 0, 60, 'Morning', true, true),

-- Sahara
('Douz - Gateway to the Sahara', 'دوز - بوابة الصحراء', 'Known as the Gateway to the Sahara. Starting point for desert excursions, camel treks, and the annual Festival of the Sahara.', 'تعرف ببوابة الصحراء نقطة انطلاق الرحلات الصحراوية', 'SAHARA', 33.4603, 8.1303, 'Douz', 'Kebili', 'Open 24/7', 0, 480, 'October to April', true, true),
('Tozeur Oasis', 'واحة توزر', 'Magnificent palm oasis with over 200,000 palm trees. Gateway to Chott el Jerid salt lake and Star Wars filming locations.', 'واحة نخيل رائعة بأكثر من 200 ألف نخلة وبوابة لشط الجريد', 'SAHARA', 33.9197, 8.1336, 'Tozeur', 'Tozeur', 'Open 24/7', 0, 240, 'October to April', true, true),
('Matmata Troglodyte Houses', 'منازل مطماطة الكهفية', 'Underground Berber dwellings carved into the rock. Famous as the filming location for Star Wars (Luke Skywalker''s home).', 'مساكن بربرية تحت الأرض منحوتة في الصخر مشهورة كموقع تصوير حرب النجوم', 'SAHARA', 33.5433, 9.9672, 'Matmata', 'Gabes', '08:00-18:00', 5, 90, 'October to April', true, true),

-- Nature
('Ichkeul National Park', 'المحمية الوطنية إشكل', 'UNESCO World Heritage Site - important wetland and lake ecosystem, home to hundreds of thousands of migrating birds.', 'موقع تراث عالمي لليونسكو - نظام بيئي للأراضي الرطبة والبحيرات', 'NATURE', 37.1608, 9.6744, 'Ichkeul, Bizerte', 'Bizerte', '08:00-17:00', 5, 180, 'November to February', true, true),
('Ain Draham', 'عين دراهم', 'A charming mountain town surrounded by cork oak forests. Known for its cool climate, waterfalls, and hiking trails.', 'مدينة جبلية ساحرة محاطة بغابات البلوط الفليني', 'NATURE', 36.7839, 8.6867, 'Ain Draham', 'Jendouba', 'Open 24/7', 0, 300, 'Spring and Autumn', true, true),

-- Adventure
('Tabarka Diving', 'غوص طبرقة', 'Premier diving destination in Tunisia with coral reefs, underwater caves, and rich marine life along the Coral Coast.', 'وجهة غوص رئيسية في تونس بشعاب مرجانية وكهوف تحت الماء', 'ADVENTURE', 36.9544, 8.7581, 'Tabarka', 'Jendouba', '08:00-17:00', 80, 180, 'June to September', false, true),

-- Shopping
('Souk El Attarine', 'سوق العطارين', 'Historic perfume and spice souk in the heart of the Medina of Tunis. Dating back centuries, filled with aromatic treasures.', 'سوق العطور والتوابل التاريخي في قلب المدينة العتيقة بتونس', 'SHOPPING', 36.7989, 10.1710, 'Medina of Tunis', 'Tunis', '09:00-18:00', 0, 60, 'Year-round', true, true);
