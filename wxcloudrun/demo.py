import cv2
import paddlehub as hub

model = hub.Module(name='U2Net')

#用函数形式写
def cv_show(name,img):
    cv2.imshow(name,img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def infer(img):
  result = model.Segmentation(
      images=[cv2.imread(img)],
      paths=None,
      batch_size=1,
      input_size=320,
      output_dir='output',
      visualization=True)
  return result[0]['front'][:,:,::-1], result[0]['mask']

