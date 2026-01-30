# FORM 2 - PROVISIONAL SPECIFICATION
## (See section 10, rule 13)

---

## TITLE OF THE INVENTION

**"A field-deployable ensemble convolutional neural network system for automated identification of pests of Sugarcane"**

---

## APPLICANT

We, **ICAR-Indian Sugarcane Research Institute**, an Indian registered body incorporated under the Registration of Societies Act (Act XXI of 1860), having its office at ICAR-Indian Sugarcane Research Institute, Raebareli Road, Lucknow-226002, India.

---

## The following specification describes the nature of this invention:

---

## FIELD OF THE INVENTION

The present invention relates to the field of agricultural technology, specifically to an artificial intelligence-based automated pest detection system for sugarcane crops. More particularly, the invention pertains to a reproducible deep learning framework comprising ensemble convolutional neural networks (CNNs) with multiple fusion strategies for field-deployable classification of pest damage in sugarcane using digital imagery.

---

## DESCRIPTION OF THE INVENTION

### Background of the Invention

Sugarcane is a significant commercial crop in India, contributing approximately 1.1% to national GDP and supporting roughly seven million farming households. The crop is cultivated in about 5.2 million hectares and is highly vulnerable to a wide range of insect pests. Major pests include stem borers (top borer, internode borer, root borer, stalk borer, and pink borer), sap-feeding insects (mealybugs), subterranean pests (termites), and vertebrate pests (rats and porcupines). Pest damage can reduce sugarcane yields by an estimated 20-46% depending on pest complex and severity.

Proper and timely identification of pest species and their injury symptoms is critical for effective crop protection but remains difficult in practice. Symptoms change with crop growth stage, multiple pests may co-occur or attack sequentially, and different pests produce overlapping visual signs leading to diagnostic errors. For instance, many borers produce "dead heart" symptoms yet differ in frass type and tunnel position. This visual confusion makes manual diagnosis error-prone, especially where skilled entomological support is limited.

### Objects of the Invention

The primary objects of the present invention are:

1. To provide a reproducible, field-deployable deep learning pipeline for automatic classification of sugarcane pest damage from images.

2. To develop and evaluate multiple CNN backbone architectures and ensemble fusion strategies for robust pest recognition.

3. To create deployable model artifacts in TorchScript and ONNX formats suitable for mobile and server applications.

4. To achieve high classification accuracy (≥96%) across eleven pest/damage categories while handling overlapping symptoms and field variability.

### Summary of the Invention

The present invention discloses a deep learning framework for automated identification of sugarcane pests comprising:

**Dataset:**
A consolidated dataset of 4,155 expert-annotated images collected from field and controlled conditions, organized into 11 classes representing ten different pest/damage types and healthy sugarcane. The dataset is split into training (80%), validation (10%), and test (10%) sets.

**Backbone CNN Architectures:**
Seven pre-trained convolutional neural network backbones are employed for feature extraction:
- AlexNet (feature dimension: 9,216)
- ResNet-50 (feature dimension: 2,048)
- Inception-V3 (feature dimension: 2,048)
- MobileNet-V2 (feature dimension: 1,280)
- EfficientNet-B0 (feature dimension: 1,280)
- DarkNet-53 (feature dimension: 1,024)
- YOLO11n-cls (feature dimension: 1,280)

**Ensemble Fusion Strategies:**
Three novel ensemble fusion mechanisms combine the backbone outputs:

1. **Concatenation Fusion:** Concatenates all extracted features (total 18,176 dimensions) and passes through fully connected layers with dropout regularization.

2. **Attention-Weighted Fusion:** Applies learnable scalar weights to backbone features before concatenation, enabling adaptive contribution from each architecture.

3. **Cross-Attention Fusion:** Projects all backbone features to a common dimension and combines through an 8-head multi-head attention mechanism for inter-model feature interaction.

**Super-Ensemble (Meta-Fusion):**
A hierarchical super-ensemble combines the logits of all three ensemble models through additional fully connected layers, achieving meta-level fusion of fusion strategies.

**Training Protocol:**
- Optimizer: AdamW with learning rate 0.001 and weight decay 1e-4
- Scheduler: OneCycleLR with maximum learning rate 0.01
- Loss: CrossEntropy with label smoothing 0.1
- Training: 30 epochs for ensembles; fivefold cross-validation for backbones
- Data augmentation: RandomResizedCrop, RandomHorizontalFlip, ColorJitter, RandomRotation

**Classification Categories:**
The system classifies sugarcane into 11 categories:
1. Healthy
2. Top borer damage
3. Stalk borer damage
4. Pink borer damage
5. Internode borer damage
6. Root borer damage
7. Army worm damage
8. Mealy bug infestation
9. Termite damage
10. Rat damage
11. Porcupine damage

**Performance Achieved:**
- Single backbone accuracy: Up to 97.12% (ResNet-50)
- Attention-weighted ensemble: 96.39% validation accuracy
- Macro-F1 score: 96.18%
- ROC-AUC: ≈0.9985
- Super-ensemble: 96.15% accuracy with stable validation dynamics

**Deployment:**
Models are exported to TorchScript and ONNX formats for deployment on mobile devices and server environments, enabling field-deployable pest diagnostics without requiring internet connectivity.

### Industrial Applicability

The present invention has significant applications in:
1. Agricultural extension services for field-based pest diagnosis
2. Farmer advisory systems using smartphone cameras
3. Integrated Pest Management (IPM) programs
4. Crop insurance documentation
5. Research institutions for large-scale pest monitoring
6. Sugar mills for monitoring pest pressure in contracted growing areas

---

**(Dinesh Singh)**
**Director**
**ICAR-Indian Sugarcane Research Institute**
**Lucknow – 226002**
